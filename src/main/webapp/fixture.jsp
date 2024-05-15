<%@ page import="java.sql.*, java.util.*, java.sql.Date, java.sql.Time, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>XPectable fixture</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">

    <link rel="stylesheet" href="resources/css/fixture.css">
    <style>
        .round {
            margin-bottom: 20px;
        }
        .date {
            margin-left: 3%;
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

<nav class="menu_box">
    <div class="logo">
        <hr />
        <a href="index.html"><h3><b style="color:#FC6736;font-size:35px">XP</b>ectable</h3></a>
        <hr />
    </div>
    <ul>
        <li><a class="home" href="index.html"><i class="fa fa-home fa-fw"></i>
                Home</a></li>
        <li><a href="fixture.html"><i class="fa fa-calendar fa-fw"></i>
                Fixture</a></li>
        <li><a href="standing.html"><i class="fa-solid fa-ranking-star fa-fw"></i>
                Standing</a></li>
        <li><a href="prediction.html"><i class="fa-solid fa-circle-question fa-fw"></i>
                Prediction</a></li>
        <li><a href="contact.html"><i class="fa fa-envelope fa-fw"></i>
                Contact</a></li>
        <li><a href="#"><i class="fa fa-comment fa-fw"></i>
                Feedback</a></li>
        <div class="social_media">
            <a href="#"><i class="fa-brands fa-linkedin" style="color:#EFECEC"></i></a>
            <a href="#"><i class="fa-brands fa-github" style="color:#EFECEC"></i></a>
        </div>
    </ul>
</nav>

<div class="filter-dropdown">
    <label for="drop-btn" class="dropdown-label">Filter:</label>
    <button onclick="dropdownFunction()" id="drop-btn" class="dropdown-btn">All</button>
    <ul id="drop-content" class="dropdown-content">
        <!-- <li><a href="#All">Filter: All</a></li> -->
        <li><a href="fixture.jsp?league_id=1">Massachusetts</a>
            <ul>
                <li><a href="fixture.jsp?league_id=1">Division 1</a></li>
                <li><a href="fixture.jsp?league_id=2">Division 2</a></li>
            </ul>
        </li>
        <li><a href="#NJ">New Jersey</a>
            <ul>
                <li><a href="#NJ-D1">Division 1</a></li>
                <li><a href="#NJ-D2">Division 2</a></li>
            </ul>
        </li>
        <li><a href="#NY">New York</a>
            <ul>
                <li><a href="#NY-D1">Division 1</a></li>
                <li><a href="#NY-D2">Division 2</a></li>
            </ul>
        </li>
        <li><a href="#PA">Pennsylvania</a>
            <ul>
                <li><a href="#PA-D1">Division 1</a></li>
                <li><a href="#PA-D2">Division 2</a></li>
            </ul>
        </li>
        <li><a href="#VA">Virginia</a>
            <ul>
                <li><a href="#VA-D1">Division 1</a></li>
                <li><a href="#VA-D2">Division 2</a></li>
            </ul>
        </li>
    </ul>
</div>
<h2 style="text-align: center; padding-top: 200px;">Fixture</h2>

<%
int currentRound = -1;
Date currentDate = null;
    // Default SQL query
    String sql = "SELECT * FROM game ORDER BY game_round, game_date";

 	// Retrieve league_id parameter from the request
    String leagueIdParam = request.getParameter("league_id");
    int leagueId = -1; // Default value or handle null case
    if (leagueIdParam != null && !leagueIdParam.isEmpty()) {
        leagueId = Integer.parseInt(leagueIdParam);
    }

    // Check if a league is selected
    String selectedLeague = request.getParameter("league_id");
    if (selectedLeague != null && !selectedLeague.isEmpty()) {
        // Append WHERE clause to filter games by league
        sql = "SELECT * FROM game INNER JOIN teams ON game.home_team_id = teams.team_id WHERE teams.league_id = ? ORDER BY game_round, game_date";
    }


    try {
        // Load the MySQL JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Establish the database connection
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/xpectable_data", "root", "MyPass123!");

        // Create the SQL query
        PreparedStatement statement = conn.prepareStatement(sql);

        // Set league parameter if applicable
        if (selectedLeague != null && !selectedLeague.isEmpty()) {
            statement.setString(1, selectedLeague);
        }

        // Execute the query
        ResultSet rs = statement.executeQuery();
        

        while (rs.next()) {
            int round = rs.getInt("game_round");
            Date gameDate = rs.getDate("game_date");

            if (round != currentRound) {
                // Start a new round
                if (currentRound != -1) {
        %>
                            </tbody>
                        </table>
                <%
                }
                %>
                <div class="round">
                    <!-- <h3>Round <%= round %></h3> -->
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
                        <h4 class="date"><%= gameDate %></h4>
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
                    <script src="resources\js\fixture.js"></script>
                    </html>
