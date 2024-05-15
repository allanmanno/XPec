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

  // JavaScript for filtering standings
function filterStandings(leagueId) {
    // Make an AJAX request to fetch standings for the selected league
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            // Update the standings table with the fetched data
            document.getElementById("standingsTable").innerHTML = this.responseText;
        }
    };
    xhttp.open("GET", "fetchStandings.jsp?league_id=" + leagueId, true);
    xhttp.send();
}

// Event listener for filter dropdown links
document.querySelectorAll('.dropdown-content a').forEach(item => {
    item.addEventListener('click', event => {
        event.preventDefault(); // Prevent default link behavior
        var leagueId = item.getAttribute('href').split("=")[1]; // Extract league ID from href
        filterStandings(leagueId); // Filter standings based on selected league ID
    });
});
