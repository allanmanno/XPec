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

<div class="filter-dropdown">
    <label for="drop-btn" class="dropdown-label">Filter:</label>
    <button onclick="dropdownFunction()" id="drop-btn" class="dropdown-btn">All</button>
    <ul id="drop-content" class="dropdown-content">
        <!-- <li><a href="#All">Filter: All</a></li> -->
        <li><a href="standing.jsp?league_id=1">Massachusetts</a>
            <ul>
                <li><a href="standing.jsp?league_id=1">Division 1</a></li>
                <li><a href="standing.jsp?league_id=2">Division 2</a></li>
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
    <!-- Main content -->
    <div class="container">
        <h2 class="text-center">League Standings</h2>
        <div class="row">
            <div class="col-md-12">
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
                        try {
                            // Establish database connection
                            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/fake_league", "root", "MyPass123!");

                         	// Retrieve the selected league ID from request parameters
                            String selectedLeague = request.getParameter("league_id");

                            // Prepare SQL query
                            String query;
                            if (selectedLeague != null && !selectedLeague.isEmpty()) {
                                query = "SELECT * FROM standing WHERE league_id = ? ORDER BY points DESC";
                            } else {
                                query = "SELECT * FROM standing ORDER BY points DESC";
                            }
                            PreparedStatement pstmt = conn.prepareStatement(query);

                         	// Set league ID parameter if applicable
                            if (selectedLeague != null && !selectedLeague.isEmpty()) {
                                pstmt.setString(1, selectedLeague);
                            }
                         
                            // Execute query
                            ResultSet rs = pstmt.executeQuery();

                            int position = 1;
                            // Iterate through results and display standings
                            while (rs.next()) {
                                String teamName = rs.getString("team_name");
                                int played = rs.getInt("game_played");
                                int won = rs.getInt("game_won");
                                int drawn = rs.getInt("game_drawn");
                                int lost = rs.getInt("game_lost");
                                int goalsFor = rs.getInt("goals_for");
                                int goalsAgainst = rs.getInt("goals_against");
                                int points = rs.getInt("points");

                                // Output standings row
                                out.println("<tr>");
                                out.println("<td>" + position + "</td>");
                                out.println("<td>" + teamName + "</td>");
                                out.println("<td>" + played + "</td>");
                                out.println("<td>" + won + "</td>");
                                out.println("<td>" + drawn + "</td>");
                                out.println("<td>" + lost + "</td>");
                                out.println("<td>" + goalsFor + "</td>");
                                out.println("<td>" + goalsAgainst + "</td>");
                                out.println("<td>" + points + "</td>");
                                out.println("</tr>");

                                position++;
                            }

                            // Close resources
                            rs.close();
                            pstmt.close();
                            conn.close();

                        } catch (Exception e) {
                            out.println("<tr><td colspan='9'>An error occurred: " + e.getMessage() + "</td></tr>");
                        }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- JavaScript for filtering standings -->
    
</body>
<script src="resources\js\fixture.js"></script>
</html>
