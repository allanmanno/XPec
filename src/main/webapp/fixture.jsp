<%@ page import="java.sql.*, java.util.*, java.sql.Date, java.sql.Time, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Fixture</title>
    <style>
        .round {
            margin-bottom: 20px;
        }
        .date {
            margin-left: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 10px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <h2>Fixture</h2>
    <%
        try {
            // Load the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Establish the database connection
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/fake_league", "root", "2636");

            // Create the SQL query
            String sql = "SELECT * FROM game ORDER BY game_round, game_date";
            PreparedStatement statement = conn.prepareStatement(sql);

            // Execute the query
            ResultSet rs = statement.executeQuery();

            int currentRound = -1;
            Date currentDate = null;

            // Process the results
            while (rs.next()) {
                int round = rs.getInt("game_round");
                Date gameDate = rs.getDate("game_date");

                if (round != currentRound) {
                    // Start a new round
                    if (currentRound != -1) {
                        // Close previous round table
            %>
                        </tbody>
                    </table>
            <%
                    }
            %>
                    <div class="round">
                        <h3>Round <%= round %></h3>
            <%
                    currentRound = round;
                }

                if (!gameDate.equals(currentDate)) {
                    // Close previous date subtable if not first date of round
                    if (currentDate != null) {
            %>
                            </tbody>
                        </table>
            <%
                    }
            %>
                        <h4 class="date">Date: <%= gameDate %></h4>
                        <table>
                            <thead>
                                <tr>
                                    <th>Home Team</th>
                                    <th>Time</th>
                                    <th>Away Team</th>
                                </tr>
                            </thead>
                            <tbody>
            <%
                    currentDate = gameDate;
                }

                // Retrieve home team name
                int homeTeamId = rs.getInt("home_team_id");
                PreparedStatement homeTeamStatement = conn.prepareStatement("SELECT team_name FROM teams WHERE team_id = ?");
                homeTeamStatement.setInt(1, homeTeamId);
                ResultSet homeTeamResult = homeTeamStatement.executeQuery();
                String homeTeamName = "";
                if (homeTeamResult.next()) {
                    homeTeamName = homeTeamResult.getString("team_name");
                }
                homeTeamStatement.close();
                homeTeamResult.close();

                // Retrieve away team name
                int awayTeamId = rs.getInt("away_team_id");
                PreparedStatement awayTeamStatement = conn.prepareStatement("SELECT team_name FROM teams WHERE team_id = ?");
                awayTeamStatement.setInt(1, awayTeamId);
                ResultSet awayTeamResult = awayTeamStatement.executeQuery();
                String awayTeamName = "";
                if (awayTeamResult.next()) {
                    awayTeamName = awayTeamResult.getString("team_name");
                }
                awayTeamStatement.close();
                awayTeamResult.close();

                // Format time in 12-hour format
                Time gameTime = rs.getTime("game_time");
                SimpleDateFormat sdf = new SimpleDateFormat("hh:mm a");
                String formattedTime = sdf.format(gameTime);
            %>
                        <tr>
                            <td><%= homeTeamName %></td>
                            <td><%= formattedTime %></td>
                            <td><%= awayTeamName %></td>
                        </tr>
            <%
            }

            // Close the last date subtable and round table
            if (currentDate != null) {
            %>
                            </tbody>
                        </table>
            <%
            }
            if (currentRound != -1) {
            %>
                    </div>
            <%
            }

            rs.close();
            statement.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>
</body>
</html>
