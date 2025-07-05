function copyToClipboard() {
    const tempInput = document.createElement("input");
    tempInput.value = "gold-age.net";
    document.body.appendChild(tempInput);
    tempInput.select();
    tempInput.setSelectionRange(0, 99999); // For mobile devices
    document.execCommand("copy");
    document.body.removeChild(tempInput);

    let notification = document.getElementById("notification");
    notification.classList.remove("hide-notification"); // Reset hiding animation
    notification.classList.add("show-notification");
    setTimeout(() => {
        notification.classList.remove("show-notification");
        notification.classList.add("hide-notification");
    }, 2000); // Keep the notification visible for 2 seconds
}

window.addEventListener('load', () => {
    const videoElem = document.getElementById('videoBackground') || createVideoElement();

    videoElem.addEventListener('loadeddata', () => {
        showContent();
    });


    videoElem.addEventListener('canplay', () => {
        showContent();
    });


    setTimeout(() => {
        if (!document.body.classList.contains('loaded')) {
            showContent();
        }
    }, 2000);

    document.querySelectorAll('.server-ip').forEach(el => {
        el.addEventListener('click', copyToClipboard);
    });

    document.querySelectorAll('a').forEach(anchor => {
        anchor.addEventListener('click', function(event) {
            if (anchor.href.includes(window.location.origin)) {
                event.preventDefault();
                document.body.classList.remove('loaded');
                videoElem.classList.remove('loaded');
                setTimeout(() => {
                    window.location = anchor.href;
                }, 500);
            }
        });
    });

    const hamburger = document.querySelector('.hamburger');
    const menu = document.querySelector('.menu');
    hamburger.addEventListener('click', () => {
        hamburger.classList.toggle('change');
        menu.classList.toggle('show');
    });
});

function createVideoElement() {
    const videoElem = document.createElement('video');
    videoElem.id = 'videoBackground';
    videoElem.className = 'video-background';
    videoElem.autoplay = true;
    videoElem.loop = true;
    videoElem.muted = true;

    const sourceElem = document.createElement('source');
    sourceElem.src = 'loop.mp4';
    sourceElem.type = 'video/mp4';

    videoElem.appendChild(sourceElem);
    document.body.appendChild(videoElem);
    return videoElem;
}

function showContent() {
    document.querySelector('.content').classList.add('show');
    document.body.classList.add('loaded');
    document.getElementById('videoBackground').classList.add('loaded');
}

function adjustTitleSize() {
    const title = document.querySelector('.navbar h1');
    const navbar = document.querySelector('.navbar');
    const hamburger = document.querySelector('.hamburger');

    if (title && navbar && hamburger) {
        const availableSpace = navbar.offsetWidth - hamburger.offsetWidth - 20; // Account for padding
        title.style.fontSize = ''; // Reset font size
        while (title.scrollWidth > availableSpace && parseFloat(getComputedStyle(title).fontSize) > 10) {
            title.style.fontSize = `${parseFloat(getComputedStyle(title).fontSize) - 1}px`;
        }
    }
}

window.addEventListener('resize', adjustTitleSize);
window.addEventListener('load', adjustTitleSize);
