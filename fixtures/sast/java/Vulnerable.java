// Deliberately insecure Java for SAST scanner testing. DO NOT run or reuse.
import java.sql.*;
import java.io.*;
import javax.servlet.http.*;

public class Vulnerable extends HttpServlet {
    // CWE-798: hard-coded credentials
    private static final String DB_PASS = "admin123";

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String name = req.getParameter("name");
        try {
            Connection c = DriverManager.getConnection("jdbc:mysql://localhost/app", "root", DB_PASS);
            Statement st = c.createStatement();
            // CWE-89: SQL injection
            ResultSet rs = st.executeQuery("SELECT * FROM users WHERE name = '" + name + "'");
            // CWE-78: command injection
            Runtime.getRuntime().exec("sh -c 'echo " + req.getParameter("msg") + "'");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
