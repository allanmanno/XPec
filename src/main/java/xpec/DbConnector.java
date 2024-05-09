package xpec;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;


public class DbConnector  {
	public static void main(String[] args){
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		
		String url = "jdbc:mysql://localhost:3306/fake_league";
		String user = "root";
		String password = "2636";
		
		try {
			conn = DriverManager.getConnection(url, user, password);
			
			stmt = conn.createStatement();
			
			String sql = "SELECT * From teams";
			
			rs = stmt.executeQuery(sql);
			
			while(rs.next()) {
				int team_id = rs.getInt("team_id");
				String team_name = rs.getString("team_name");
				int league_id = rs.getInt("league_id");
				
				System.out.println("Team ID: " + team_id + " Team Name: " + team_name + " League ID: " + league_id);
			}
		}catch(SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				if(rs != null) rs.close();
				if(stmt != null) stmt.close();
				if(conn != null) conn.close();
			}catch(SQLException e) {
				e.printStackTrace();
			}
		}
	}
}
