const COMMENT_STORAGE_KEY = "comments";
const THEME_STORAGE_KEY = "theme";
const GITHUB_USERNAME = "nertonm";
const FALLING_AVOCADO_COUNT = 100;

const colors = ["#16a085", "#1abc9c", "#f39c12", "#e74c3c", "#9b59b6"];

let hireMe;
let basket;
let counter;
let muteButton;
let projectList = [];
let hireMeX = 100;
let hireMeY = 100;
let direction = { x: 1, y: 1 };
let capturedAvocados = [];
let avocadoCount = 0;
let speed = 10;
let isMuted = false;

function getStoredComments() {
    try {
        const storedComments = localStorage.getItem(COMMENT_STORAGE_KEY);
        const comments = storedComments ? JSON.parse(storedComments) : [];
        return Array.isArray(comments) ? comments : [];
    } catch (error) {
        console.warn("Nao foi possivel ler os comentarios salvos.", error);
        return [];
    }
}

function setStoredComments(comments) {
    localStorage.setItem(COMMENT_STORAGE_KEY, JSON.stringify(comments));
}

function addComment() {
    const commentInput = document.getElementById("comment");
    if (!commentInput) {
        return;
    }

    const comment = commentInput.value.trim();
    if (!comment) {
        return;
    }

    const comments = getStoredComments();
    comments.push(comment);
    setStoredComments(comments);
    commentInput.value = "";
    displayComments();
}

function displayComments() {
    const commentContainer = document.getElementById("comments");
    if (!commentContainer) {
        return;
    }

    commentContainer.replaceChildren();

    for (const comment of getStoredComments()) {
        const paragraph = document.createElement("p");
        paragraph.textContent = `📝 ${comment}`;
        commentContainer.appendChild(paragraph);
    }
}

function createFallingAvocados() {
    const container = document.querySelector(".falling-avocados");
    if (!container) {
        return;
    }

    for (let index = 0; index < FALLING_AVOCADO_COUNT; index += 1) {
        const avocado = document.createElement("div");
        avocado.classList.add("avocado");
        avocado.textContent = "🥑";
        avocado.style.left = `${Math.random() * 100}vw`;
        avocado.style.animationDuration = `${Math.random() * 3 + 2}s`;
        avocado.style.animationDelay = `${Math.random() * 5}s`;
        container.appendChild(avocado);
    }
}

function openExternalLink(url) {
    const newWindow = window.open(url, "_blank", "noopener,noreferrer");
    if (newWindow) {
        newWindow.opener = null;
    }
}

function buildProjectListItem(repo) {
    const listItem = document.createElement("li");
    const link = document.createElement("a");

    link.href = repo.html_url;
    link.target = "_blank";
    link.rel = "noopener noreferrer";
    link.textContent = repo.name;

    listItem.appendChild(link);
    listItem.append(` - ${repo.description || "Sem descricao"}`);
    return listItem;
}

async function loadGitHubProjects() {
    const projectListElement = document.getElementById("project-list");
    if (!projectListElement) {
        return;
    }

    try {
        const response = await fetch(
            `https://api.github.com/users/${GITHUB_USERNAME}/repos?per_page=100&sort=updated`
        );
        if (!response.ok) {
            throw new Error(`Erro ao buscar repositorios: ${response.status}`);
        }

        const repos = await response.json();
        projectList = repos
            .filter((repo) => !repo.fork || repo.stargazers_count >= 2)
            .sort((leftRepo, rightRepo) => rightRepo.stargazers_count - leftRepo.stargazers_count)
            .slice(0, 100);

        projectListElement.replaceChildren(
            ...projectList.map((repo) => buildProjectListItem(repo))
        );
    } catch (error) {
        console.error("Erro ao carregar repositorios:", error);
        const errorItem = document.createElement("li");
        errorItem.textContent = "Nao foi possivel carregar os projetos.";
        projectListElement.replaceChildren(errorItem);
    }
}

function applySavedTheme() {
    const savedTheme = localStorage.getItem(THEME_STORAGE_KEY);
    document.body.classList.toggle("dark-theme", savedTheme === "dark");
}

function initializeThemeToggle() {
    const themeToggle = document.getElementById("theme-toggle");
    if (!themeToggle) {
        return;
    }

    themeToggle.addEventListener("click", () => {
        document.body.classList.toggle("dark-theme");
        const isDarkTheme = document.body.classList.contains("dark-theme");
        localStorage.setItem(THEME_STORAGE_KEY, isDarkTheme ? "dark" : "light");
    });
}

function updateCounter() {
    if (counter) {
        counter.textContent = `Abacates: ${avocadoCount}`;
    }

    updateHireMe();
}

function updateHireMe() {
    speed = 10 + avocadoCount * 2;

    if (avocadoCount > 0 && avocadoCount % 5 === 0) {
        addNewProjectFromList();
    }
}

function moveHireMe() {
    if (!hireMe) {
        return;
    }

    hireMeX += direction.x * speed;
    hireMeY += direction.y * speed;

    const maxWidth = window.innerWidth - hireMe.offsetWidth;
    const maxHeight = window.innerHeight - hireMe.offsetHeight;

    if (hireMeX <= 0 || hireMeX >= maxWidth) {
        direction.x *= -1;
        hireMeX = Math.max(0, Math.min(hireMeX, maxWidth));
    }

    if (hireMeY <= 0 || hireMeY >= maxHeight) {
        direction.y *= -1;
        hireMeY = Math.max(0, Math.min(hireMeY, maxHeight));
    }

    hireMe.style.transform = `translate(${hireMeX}px, ${hireMeY}px)`;
}

function overlapsPortfolioBox(left, top, width, height, portfolioRect) {
    return (
        left < portfolioRect.right &&
        left + width > portfolioRect.left &&
        top < portfolioRect.bottom &&
        top + height > portfolioRect.top
    );
}

function positionProjectElement(projectElement) {
    const portfolioBox = document.getElementById("portfolio-box");
    const portfolioRect = portfolioBox ? portfolioBox.getBoundingClientRect() : null;
    const { width, height } = projectElement.getBoundingClientRect();
    const maxLeft = Math.max(0, window.innerWidth - width);
    const maxTop = Math.max(0, window.innerHeight - height);
    let left = 0;
    let top = 0;
    let attempts = 0;

    do {
        left = Math.random() * maxLeft;
        top = Math.random() * maxTop;
        attempts += 1;
    } while (
        portfolioRect &&
        overlapsPortfolioBox(left, top, width, height, portfolioRect) &&
        attempts < 50
    );

    if (portfolioRect && attempts >= 50) {
        const rightSideLeft = Math.min(maxLeft, portfolioRect.right + 16);
        const leftSideLeft = Math.max(0, portfolioRect.left - width - 16);

        left = rightSideLeft < maxLeft ? rightSideLeft : leftSideLeft;
        top = Math.max(0, Math.min(maxTop, portfolioRect.top));
    }

    projectElement.style.left = `${left}px`;
    projectElement.style.top = `${top}px`;
    projectElement.style.visibility = "visible";
}

function addNewProjectFromList() {
    if (projectList.length === 0) {
        return;
    }

    const repo = projectList.shift();
    if (repo.fork && repo.stargazers_count < 3) {
        addNewProjectFromList();
        return;
    }

    const newProject = document.createElement("div");
    newProject.classList.add("project");
    newProject.textContent = repo.name;
    newProject.style.position = "absolute";
    newProject.style.padding = "10px";
    newProject.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
    newProject.style.color = "#fff";
    newProject.style.display = "flex";
    newProject.style.alignItems = "center";
    newProject.style.justifyContent = "center";
    newProject.style.borderRadius = "10px";
    newProject.style.cursor = "pointer";
    newProject.style.whiteSpace = "nowrap";
    newProject.style.width = "auto";
    newProject.style.height = "auto";
    newProject.style.visibility = "hidden";
    newProject.style.left = "-9999px";
    newProject.style.top = "-9999px";

    newProject.addEventListener("click", (event) => {
        event.preventDefault();
        openExternalLink(repo.html_url);
        newProject.remove();
    });

    document.body.appendChild(newProject);
    positionProjectElement(newProject);
}

function handleHireMeClick() {
    if (!hireMe || capturedAvocados.length === 0) {
        return;
    }

    hireMe.classList.add("exploded");

    for (const avocado of capturedAvocados) {
        avocado.style.position = "absolute";
        avocado.style.left = `${Math.random() * window.innerWidth}px`;
        avocado.style.top = `${Math.random() * window.innerHeight}px`;
        document.body.appendChild(avocado);
    }

    capturedAvocados = [];
    avocadoCount = 0;
    updateCounter();

    window.setTimeout(() => {
        hireMe.classList.remove("exploded");
    }, 1000);
}

function isColliding(firstElement, secondElement) {
    const firstRect = firstElement.getBoundingClientRect();
    const secondRect = secondElement.getBoundingClientRect();

    return !(
        firstRect.top > secondRect.bottom ||
        firstRect.bottom < secondRect.top ||
        firstRect.left > secondRect.right ||
        firstRect.right < secondRect.left
    );
}

function playPlimSound() {
    if (isMuted) {
        return;
    }

    const sound = new Audio("./plim.mp3");
    void sound.play().catch(() => {});
}

function checkAvocadoCollision() {
    if (!basket) {
        return;
    }

    const avocados = document.querySelectorAll(".avocado");
    avocados.forEach((avocado) => {
        if (!isColliding(avocado, basket)) {
            return;
        }

        avocado.remove();
        avocadoCount += 1;
        capturedAvocados.push(avocado);
        updateCounter();
        playPlimSound();
    });
}

function initializeBasket() {
    if (!basket) {
        return;
    }

    const centeredLeft = Math.max(0, (window.innerWidth - basket.offsetWidth) / 2);
    basket.style.left = `${centeredLeft}px`;

    document.addEventListener("mousemove", (event) => {
        const basketWidth = basket.offsetWidth;
        const maxBasketX = window.innerWidth - basketWidth;
        const basketX = Math.max(0, Math.min(event.clientX - basketWidth / 2, maxBasketX));
        basket.style.left = `${basketX}px`;
    });
}

function initializeMuteButton() {
    if (!muteButton) {
        return;
    }

    muteButton.addEventListener("click", () => {
        isMuted = !isMuted;
        muteButton.textContent = isMuted ? "🔇" : "🔊";
    });
}

function initializeComments() {
    const addCommentButton = document.getElementById("add-comment");
    const commentInput = document.getElementById("comment");

    displayComments();

    if (addCommentButton) {
        addCommentButton.addEventListener("click", addComment);
    }

    if (commentInput) {
        commentInput.addEventListener("keydown", (event) => {
            if ((event.ctrlKey || event.metaKey) && event.key === "Enter") {
                addComment();
            }
        });
    }
}

function initializeHireMe() {
    if (!hireMe) {
        return;
    }

    window.setInterval(() => {
        const randomColor = colors[Math.floor(Math.random() * colors.length)];
        hireMe.style.color = randomColor;
    }, 500);

    window.setInterval(moveHireMe, 50);
    window.setInterval(checkAvocadoCollision, 100);
    hireMe.addEventListener("click", handleHireMeClick);
}

function clampFloatingElementsOnResize() {
    if (!hireMe || !basket) {
        return;
    }

    const maxHireMeX = Math.max(0, window.innerWidth - hireMe.offsetWidth);
    const maxHireMeY = Math.max(0, window.innerHeight - hireMe.offsetHeight);
    hireMeX = Math.max(0, Math.min(hireMeX, maxHireMeX));
    hireMeY = Math.max(0, Math.min(hireMeY, maxHireMeY));

    const basketLeft = parseFloat(basket.style.left || "0");
    const maxBasketLeft = Math.max(0, window.innerWidth - basket.offsetWidth);
    basket.style.left = `${Math.max(0, Math.min(basketLeft, maxBasketLeft))}px`;

    hireMe.style.transform = `translate(${hireMeX}px, ${hireMeY}px)`;
}

document.addEventListener("DOMContentLoaded", () => {
    hireMe = document.getElementById("hire-me");
    basket = document.getElementById("basket");
    counter = document.getElementById("counter");
    muteButton = document.getElementById("mute-button");

    initializeComments();
    applySavedTheme();
    initializeThemeToggle();
    initializeMuteButton();
    initializeBasket();
    initializeHireMe();
    createFallingAvocados();
    loadGitHubProjects();
    updateCounter();

    window.addEventListener("resize", clampFloatingElementsOnResize);
});
