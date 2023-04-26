function toggleActive(event) {
    document.querySelectorAll('.slot-btn.active').forEach((activeEl) => activeEl.classList.remove('active'))
    event.target.classList.add('active')
}

function toggleDateActive(event) {
    document.querySelectorAll('.slot-date-btn.active').forEach((activeEl) => activeEl.classList.remove('active'))
    event.target.classList.add('active')
}

function toggleCurrencyActive(event) {
    event.preventDefault()
    document.querySelectorAll('.cur-btn.active').forEach((activeEl) => activeEl.classList.remove('active'))
    event.target.classList.add('active')
    document.getElementById("user_currency").value = event.target.value
}

function countdown_timer(slot_time) {

    var now = new Date().getTime();

    var total_time_left = slot_time - now;

    var days = Math.floor(total_time_left / (1000 * 60 * 60 * 24));
    var hours = Math.floor((total_time_left % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
    var minutes = Math.floor((total_time_left % (1000 * 60 * 60)) / (1000 * 60));
    var seconds = Math.floor((total_time_left % (1000 * 60)) / 1000);

    if (total_time_left < 0) {
        clearInterval(x);
        document.getElementById("days_tens").innerHTML = 0;
        document.getElementById("days_ones").innerHTML = 0;
        document.getElementById("hours_tens").innerHTML = 0;
        document.getElementById("hours_ones").innerHTML = 0;
        document.getElementById("minutes_tens").innerHTML = 0;
        document.getElementById("minutes_ones").innerHTML = 0;
        document.getElementById("seconds_tens").innerHTML = 0;
        document.getElementById("seconds_ones").innerHTML = 0;
    }
    else {
        document.getElementById("days_tens").innerHTML = Math.floor(days/10);
        document.getElementById("days_ones").innerHTML = days%10;
        document.getElementById("hours_tens").innerHTML = Math.floor(hours/10);
        document.getElementById("hours_ones").innerHTML = hours%10;
        document.getElementById("minutes_tens").innerHTML = Math.floor(minutes/10);
        document.getElementById("minutes_ones").innerHTML = minutes%10;
        document.getElementById("seconds_tens").innerHTML = Math.floor(seconds/10);
        document.getElementById("seconds_ones").innerHTML = seconds%10;
    }
}

function leftScroll() {
    const left = document.querySelector(".scroll-date-buttons");
    left.scrollBy(-200, 0);
}
function rightScroll() {
    const right = document.querySelector(".scroll-date-buttons");
    right.scrollBy(200, 0);
}

function loader() {
    document.querySelector(".form-section" ).style.display = "none";
    document.getElementById("loader").classList.remove("d-none")
}

