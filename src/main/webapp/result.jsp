<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Game Results</title>
    <style>
        .subtable {
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <h2>Game Results</h2>
    <%
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/fake_league", "root", "2636");
            stmt = conn.prepareStatement("SELECT DISTINCT game_date FROM game ORDER BY game_date");
            rs = stmt.executeQuery();

            while (rs.next()) {
                String gameDate = rs.getString("game_date");
    %>
    <h3><%= gameDate %></h3>
    <table class="subtable" border="1">
        <tr>
            <th>Home Team</th>
            <th><%= "Home Score" %></th>
            <th><%= "Away Score" %></th>
            <th>Away Team</th>
        </tr>
        <%
            PreparedStatement stmtGames = conn.prepareStatement("SELECT g.game_id, r.result_id, t1.team_name AS home_team, t2.team_name AS away_team, r.home_team_score, r.away_team_score " +
                                        "FROM game g " +
                                        "JOIN teams t1 ON g.home_team_id = t1.team_id " +
                                        "JOIN teams t2 ON g.away_team_id = t2.team_id " +
                                        "LEFT JOIN result r ON g.game_id = r.game_id " +
                                        "WHERE g.game_date = ?");
            stmtGames.setString(1, gameDate);
            ResultSet rsGames = stmtGames.executeQuery();

            while (rsGames.next()) {
                String homeTeam = rsGames.getString("home_team");
                String awayTeam = rsGames.getString("away_team");
                int homeScore = rsGames.getInt("home_team_score");
                int awayScore = rsGames.getInt("away_team_score");
                int resultId = rsGames.getInt("result_id");

                if (resultId != 0) {
        %>
        <tr>
            <td><%= homeTeam %></td>
            <td><%= homeScore %></td>
            <td><%= awayScore %></td>
            <td><%= awayTeam %></td>
        </tr>
        <%
                } else {
        %>
        <tr>
            <td><%= homeTeam %></td>
            <td></td>
            <td></td>
            <td><%= awayTeam %></td>
        </tr>
        <%
                }
            }
            rsGames.close();
            stmtGames.close();
        %>
    </table>
    <%
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>
</body>
</html>
