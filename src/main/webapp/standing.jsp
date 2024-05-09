<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<%@ page import="xpec.StandingUtils" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>League Standings</title>
    <style>
        table {
            border-collapse: collapse;
            width: 100%;
        }

        th, td {
            border: 1px solid #dddddd;
            text-align: left;
            padding: 8px;
        }

        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <h2>League Standings</h2>
    <table>
        <tr>
            <th>Position</th>
            <th>Team</th>
            <th>Played</th>
            <th>Won</th>
            <th>Drawn</th>
            <th>Lost</th>
            <th>Goals For</th>
            <th>Goals Against</th>
            <th>Points</th>
        </tr>
        <% 
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/fake_league", "root", "2636");
                stmt = conn.prepareStatement("SELECT t.team_id, t.team_name, " +
                                               "COUNT(CASE WHEN s.home_team_id = t.team_id THEN 1 END) AS home_games, " +
                                               "COUNT(CASE WHEN s.away_team_id = t.team_id THEN 1 END) AS away_games, " +
                                               "SUM(CASE WHEN s.home_team_id = t.team_id THEN s.game_won ELSE 0 END) AS home_won, " +
                                               "SUM(CASE WHEN s.away_team_id = t.team_id THEN s.game_won ELSE 0 END) AS away_won, " +
                                               "SUM(CASE WHEN s.home_team_id = t.team_id THEN s.game_drawn ELSE 0 END) AS home_drawn, " +
                                               "SUM(CASE WHEN s.away_team_id = t.team_id THEN s.game_drawn ELSE 0 END) AS away_drawn, " +
                                               "SUM(CASE WHEN s.home_team_id = t.team_id THEN s.game_lost ELSE 0 END) AS home_lost, " +
                                               "SUM(CASE WHEN s.away_team_id = t.team_id THEN s.game_lost ELSE 0 END) AS away_lost, " +
                                               "SUM(CASE WHEN s.home_team_id = t.team_id THEN s.goals_for ELSE 0 END) AS home_goals_for, " +
                                               "SUM(CASE WHEN s.away_team_id = t.team_id THEN s.goals_for ELSE 0 END) AS away_goals_for, " +
                                               "SUM(CASE WHEN s.home_team_id = t.team_id THEN s.goals_against ELSE 0 END) AS home_goals_against, " +
                                               "SUM(CASE WHEN s.away_team_id = t.team_id THEN s.goals_against ELSE 0 END) AS away_goals_against, " +
                                               "(SUM(CASE WHEN s.home_team_id = t.team_id THEN s.game_won ELSE 0 END) + " +
                                               "SUM(CASE WHEN s.away_team_id = t.team_id THEN s.game_won ELSE 0 END)) * 3 + " +
                                               "(SUM(CASE WHEN s.home_team_id = t.team_id THEN s.game_drawn ELSE 0 END) + " +
                                               "SUM(CASE WHEN s.away_team_id = t.team_id THEN s.game_drawn ELSE 0 END)) AS points " +
                                               "FROM teams t " +
                                               "LEFT JOIN standing s ON t.team_id = s.team_id " +
                                               "GROUP BY t.team_id, t.team_name " +
                                               "ORDER BY points DESC");
                rs = stmt.executeQuery();

                int position = 1;
                while (rs.next()) {
        %>
        <tr>
            <td><%= position++ %></td>
            <td><%= rs.getString("team_name") %></td>
            <td><%= rs.getInt("home_games") + rs.getInt("away_games") %></td>
            <td><%= rs.getInt("home_won") + rs.getInt("away_won") %></td>
            <td><%= rs.getInt("home_drawn") + rs.getInt("away_drawn") %></td>
            <td><%= rs.getInt("home_lost") + rs.getInt("away_lost") %></td>
            <td><%= rs.getInt("home_goals_for") + rs.getInt("away_goals_for") %></td>
            <td><%= rs.getInt("home_goals_against") + rs.getInt("away_goals_against") %></td>
            <td><%= rs.getInt("points") %></td>
        </tr>
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
    </table>
</body>
</html>
