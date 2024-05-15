<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>League Standings</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="resources/css/standing.css">
    <!-- Inline CSS for styling -->
    <style>
        /* Add your custom CSS styles here */
    </style>
</head>
<body>
    <!-- Navigation Menu -->
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

    <!-- Filter dropdown -->
    <div class="filter-dropdown">
        <label for="drop-btn" class="dropdown-label">Filter:</label>
        <button onclick="dropdownFunction()" id="drop-btn" class="dropdown-btn">All</button>
        <ul id="drop-content" class="dropdown-content">
            <li><a href="standing.jsp">All</a></li>
            <li><a href="standing.jsp?league_id=1">Massachusetts</a>
                <ul>
                    <li><a href="standing.jsp?league_id=1">Division 1</a></li>
                    <li><a href="standing.jsp?league_id=2">Division 2</a></li>
                </ul>
            </li>
            <!-- Add other leagues as needed -->
        </ul>
    </div>

    <!-- Main content -->
    <div class="container">
        <h2 class="text-center">League Standings</h2>

        <% 
        try {
            // Establish database connection
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/fake_league", "root", "MyPass123!");

            // Retrieve selected league ID from request parameters
            String leagueIdParam = request.getParameter("league_id");
            int selectedLeagueId = -1; // Default value if parameter is not provided
            if (leagueIdParam != null && !leagueIdParam.isEmpty()) {
                selectedLeagueId = Integer.parseInt(leagueIdParam);
            }

            // If a league is selected, display its standings in a table
            if (selectedLeagueId != -1) {
                // Prepare SQL query to fetch standings for the selected league
                String standingsQuery = "SELECT * FROM standing WHERE league_id = ?";
                PreparedStatement standingsStatement = conn.prepareStatement(standingsQuery);
                standingsStatement.setInt(1, selectedLeagueId);
                ResultSet standingsResult = standingsStatement.executeQuery();
                
             // Fetch league name for the selected league
                String leagueNameQuery = "SELECT league_name FROM league WHERE league_id = ?";
                PreparedStatement leagueNameStatement = conn.prepareStatement(leagueNameQuery);
                leagueNameStatement.setInt(1, selectedLeagueId);
                ResultSet leagueNameResult = leagueNameStatement.executeQuery();
                String leagueName = "";
                if (leagueNameResult.next()) {
                    leagueName = leagueNameResult.getString("league_name");
                }
        %>

        <!-- Standings table for the selected league -->
        <h3><%= leagueName %></h3>
        <table class="table">
            <thead>
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
            </thead>
            <tbody>
                <% 
                int position = 1;
                // Iterate through results and display standings
                while (standingsResult.next()) {
                    String teamName = standingsResult.getString("team_name");
                    int played = standingsResult.getInt("game_played");
                    int won = standingsResult.getInt("game_won");
                    int drawn = standingsResult.getInt("game_drawn");
                    int lost = standingsResult.getInt("game_lost");
                    int goalsFor = standingsResult.getInt("goals_for");
                    int goalsAgainst = standingsResult.getInt("goals_against");
                    int points = standingsResult.getInt("points");

                    // Output standings row
                %>
                    <tr>
                        <td><%= position %></td>
                        <td><%= teamName %></td>
                        <td><%= played %></td>
                        <td><%= won %></td>
                        <td><%= drawn %></td>
                        <td><%= lost %></td>
                        <td><%= goalsFor %></td>
                        <td><%= goalsAgainst %></td>
                        <td><%= points %></td>
                    </tr>
                <% 
                    position++;
                }
                // Close standings result set and statement
                standingsResult.close();
                standingsStatement.close();
                %>
            </tbody>
        </table>

        <% 
            } else {
                // If no league is selected, display standings for all leagues in separate tables
                // Prepare SQL query to fetch standings for all leagues
                String leagueIdsQuery = "SELECT DISTINCT league_id FROM standing";
                PreparedStatement leagueIdsStatement = conn.prepareStatement(leagueIdsQuery);
                ResultSet leagueIdsResult = leagueIdsStatement.executeQuery();

                // Iterate through all leagues and display standings in separate tables
                while (leagueIdsResult.next()) {
                	// Extract league ID
                    int leagueId = leagueIdsResult.getInt("league_id");
                    // Fetch league name for the current league
                    String leagueNameQuery = "SELECT league_name FROM league WHERE league_id = ?";
                    PreparedStatement leagueNameStatement = conn.prepareStatement(leagueNameQuery);
                    leagueNameStatement.setInt(1, leagueId);
                    ResultSet leagueNameResult = leagueNameStatement.executeQuery();
                    String leagueName = "";
                    if (leagueNameResult.next()) {
                        leagueName = leagueNameResult.getString("league_name");
                    }
                    // Prepare SQL query to fetch standings for the current league
                    String standingsQuery = "SELECT * FROM standing WHERE league_id = ?";
                    PreparedStatement standingsStatement = conn.prepareStatement(standingsQuery);
                    standingsStatement.setInt(1, leagueId);
                    ResultSet standingsResult = standingsStatement.executeQuery();
        %>

        <!-- Standings table for league <%= leagueName %> -->
        <h3><%= leagueName %></h3>
        <table class="table">
            <thead>
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
            </thead>
            <tbody>
                <% 
                int position = 1;
                // Iterate through results and display standings
                while (standingsResult.next()) {
                    String teamName = standingsResult.getString("team_name");
                    int played = standingsResult.getInt("game_played");
                    int won = standingsResult.getInt("game_won");
                    int drawn = standingsResult.getInt("game_drawn");
                    int lost = standingsResult.getInt("game_lost");
                    int goalsFor = standingsResult.getInt("goals_for");
                    int goalsAgainst = standingsResult.getInt("goals_against");
                    int points = standingsResult.getInt("points");

                    // Output standings row
                %>
                    <tr>
                        <td><%= position %></td>
                        <td><%= teamName %></td>
                        <td><%= played %></td>
                        <td><%= won %></td>
                        <td><%= drawn %></td>
                        <td><%= lost %></td>
                        <td><%= goalsFor %></td>
                        <td><%= goalsAgainst %></td>
                        <td><%= points %></td>
                    </tr>
                <% 
                    position++;
                }
                // Close standings result set and statement
                standingsResult.close();
                standingsStatement.close();
                %>
            </tbody>
        </table>

        <% 
                }
                // Close league IDs result set and statement
                leagueIdsResult.close();
                leagueIdsStatement.close();
            }
            // Close database connection
            conn.close();
        } catch (Exception e) {
            // Handle exceptions
            e.printStackTrace();
        }
        %>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- JavaScript for filtering standings -->
    <script>
        function dropdownFunction(){
            document.getElementById("drop-content").classList.toggle("show");
        }

        window.onclick = function(event) {
            if (!event.target.matches('.dropdown-btn')) {
                var dropdowns = document.getElementsByClassName("dropdown-content");
                var i;
                for (i = 0; i < dropdowns.length; i++) {
                    var openDropdown = dropdowns[i];
                    if (openDropdown.classList.contains('show')) {
                        openDropdown.classList.remove('show');
                    }
                }
            }
        }
    </script>
</body>
</html>
