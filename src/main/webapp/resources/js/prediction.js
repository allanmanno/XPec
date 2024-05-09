function myFunction() {
   window.location.assign("pre.html");
   let state1 = document.getElementById('states').value;
   let division1 = document.getElementById('division').value;
   sessionStorage.setItem("leagueName1", state1);
   sessionStorage.setItem("leagueDivision1", division1);
}
// export {myFunction};