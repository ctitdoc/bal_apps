package cosmobilis.mysql5;

import java.sql.*;
import java.util.concurrent.*;
import org.json.JSONArray;
import org.json.JSONObject;

public class DatabaseWrapper {
    private static final int POOL_SIZE = 50;              // nb max de connexions
    private static final long TIMEOUT_SEC = 300;           // délai max d’attente

    private static BlockingQueue<Connection> pool;
    private static volatile boolean initialized = false;

    // Initialisation du pool à la première utilisation
    private static synchronized void initPool(String url, String user, String password) throws SQLException {
        if (initialized) return;

        pool = new ArrayBlockingQueue<>(POOL_SIZE);
        for (int i = 0; i < POOL_SIZE; i++) {
            pool.add(DriverManager.getConnection(url, user, password));
        }
        initialized = true;

        // Shutdown hook : fermeture propre à la fin du process (si SIGTERM)
        Runtime.getRuntime().addShutdownHook(new Thread(() -> {
            try {
                closePool();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }));
    }

    // Instance : on garde l’URL + identifiants pour recréer si besoin
    private final String url;
    private final String user;
    private final String password;

    public DatabaseWrapper(String url, String user, String password) throws SQLException {
        this.url = url;
        this.user = user;
        this.password = password;
        initPool(url, user, password);
    }

    // Récupère une connexion avec timeout
    private Connection borrowConnection() throws SQLException {
        try {
            Connection conn = pool.poll(TIMEOUT_SEC, TimeUnit.SECONDS);
            if (conn == null || conn.isClosed()) {
                throw new SQLException("Aucune connexion disponible après " + TIMEOUT_SEC + "s");
            }
            return conn;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new SQLException("Interrompu en attendant une connexion", e);
        }
    }

    // Remet une connexion dans le pool
    private void returnConnection(Connection conn) {
        if (conn != null) {
            pool.offer(conn); // remet dans la queue sans bloquer
        }
    }

    // Fermeture manuelle (rarement utile si shutdown hook actif)
    public static void closePool() throws SQLException {
        if (pool != null) {
            for (Connection conn : pool) {
                if (conn != null && !conn.isClosed()) {
                    conn.close();
                }
            }
            pool.clear();
        }
    }

    public void close() throws SQLException {
        // on ferme pas ici → c’est géré par le pool
    }

    public int executeUpdate(String sql) throws SQLException {
        Connection conn = borrowConnection();
        try (Statement stmt = conn.createStatement()) {
            return stmt.executeUpdate(sql);
        } finally {
            returnConnection(conn);
        }
    }

    public String executeQueryAsJson(String sql) throws SQLException {
        Connection conn = borrowConnection();
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            ResultSetMetaData meta = rs.getMetaData();
            int columnCount = meta.getColumnCount();
            JSONArray arr = new JSONArray();

            while (rs.next()) {
                JSONObject obj = new JSONObject();
                for (int i = 1; i <= columnCount; i++) {
                    String colName = meta.getColumnLabel(i);
                    Object value = rs.getObject(i);

                    if (value != null && "json".equalsIgnoreCase(meta.getColumnTypeName(i))) {
                        obj.put(colName, new JSONObject(value.toString()));
                    } else {
                        obj.put(colName, value);
                    }
                }
                arr.put(obj);
            }
            return arr.toString();

        } finally {
            returnConnection(conn);
        }
    }
}
