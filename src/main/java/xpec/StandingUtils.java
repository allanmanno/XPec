package xpec;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class StandingUtils {

    public static String getTeamName(int teamId, Connection conn) throws SQLException {
        PreparedStatement teamStmt = conn.prepareStatement("SELECT team_name FROM teams WHERE team_id = ?");
        teamStmt.setInt(1, teamId);
        ResultSet teamRs = teamStmt.executeQuery();
        if (teamRs.next()) {
            return teamRs.getString("team_name");
        }
        return "N/A";
    }
}