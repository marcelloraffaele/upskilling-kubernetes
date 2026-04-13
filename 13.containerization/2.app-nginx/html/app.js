/* ===================================================================
   app.js – La Bella Italia Restaurant
   =================================================================== */

// ── Menu data ──────────────────────────────────────────────────────
const menuItems = [
  // Starters
  { emoji: '🥗', name: 'Bruschetta al Pomodoro', desc: 'Toasted bread, fresh tomatoes, basil & garlic.', price: '€ 7', category: 'starter' },
  { emoji: '🧀', name: 'Burrata con Prosciutto', desc: 'Creamy burrata, cured ham & rocket leaves.', price: '€ 12', category: 'starter' },
  { emoji: '🦑', name: 'Calamari Fritti', desc: 'Golden fried squid rings with lemon aioli.', price: '€ 10', category: 'starter' },
  { emoji: '🍅', name: 'Caprese Classica', desc: 'Buffalo mozzarella, heirloom tomatoes & basil oil.', price: '€ 9', category: 'starter' },
  // Main
  { emoji: '🍝', name: 'Spaghetti Carbonara', desc: 'Guanciale, eggs, Pecorino Romano & black pepper.', price: '€ 16', category: 'main' },
  { emoji: '🍕', name: 'Pizza Margherita', desc: 'San Marzano tomato, fior di latte & fresh basil.', price: '€ 14', category: 'main' },
  { emoji: '🥩', name: 'Ossobuco alla Milanese', desc: 'Braised veal shank with gremolata & saffron risotto.', price: '€ 24', category: 'main' },
  { emoji: '🐟', name: 'Branzino al Forno', desc: 'Whole sea bass, capers, olives & cherry tomatoes.', price: '€ 22', category: 'main' },
  { emoji: '🍝', name: 'Tagliatelle al Ragù', desc: 'Slow-cooked Bolognese sauce on fresh egg pasta.', price: '€ 18', category: 'main' },
  // Desserts
  { emoji: '🍮', name: 'Tiramisù Classico', desc: 'Espresso-soaked savoiardi, mascarpone & cocoa.', price: '€ 8', category: 'dessert' },
  { emoji: '🍨', name: 'Panna Cotta alla Vaniglia', desc: 'Silky vanilla cream with wild berry coulis.', price: '€ 7', category: 'dessert' },
  { emoji: '🍰', name: 'Cannoli Siciliani', desc: 'Crispy pastry shells filled with sweet ricotta.', price: '€ 9', category: 'dessert' },
];

// ── Render menu ────────────────────────────────────────────────────
function renderMenu(filter = 'all') {
  const grid = document.getElementById('menuGrid');
  const items = filter === 'all' ? menuItems : menuItems.filter(i => i.category === filter);

  grid.innerHTML = items.map(item => `
    <div class="menu-card">
      <div class="menu-card-emoji">${item.emoji}</div>
      <div class="menu-card-body">
        <h3>${item.name}</h3>
        <p>${item.desc}</p>
        <div class="menu-card-footer">
          <span class="menu-price">${item.price}</span>
          <span class="menu-badge badge-${item.category}">${item.category}</span>
        </div>
      </div>
    </div>
  `).join('');
}

// ── Filter buttons ─────────────────────────────────────────────────
document.querySelectorAll('.filter-btn').forEach(btn => {
  btn.addEventListener('click', () => {
    document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    renderMenu(btn.dataset.filter);
  });
});

// ── Animated counters ──────────────────────────────────────────────
function animateCounter(el) {
  const target = parseInt(el.dataset.target, 10);
  const duration = 1800;
  const step = Math.ceil(target / (duration / 16));
  let current = 0;

  const timer = setInterval(() => {
    current = Math.min(current + step, target);
    el.textContent = current.toLocaleString();
    if (current >= target) clearInterval(timer);
  }, 16);
}

const observer = new IntersectionObserver(entries => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.querySelectorAll('.stat-number').forEach(animateCounter);
      observer.unobserve(entry.target);
    }
  });
}, { threshold: 0.4 });

const aboutSection = document.querySelector('.about');
if (aboutSection) observer.observe(aboutSection);

// ── Contact form ───────────────────────────────────────────────────
document.getElementById('contactForm').addEventListener('submit', function (e) {
  e.preventDefault();
  const feedback = document.getElementById('formFeedback');
  const name  = document.getElementById('nameInput').value.trim();
  const email = document.getElementById('emailInput').value.trim();
  const date  = document.getElementById('dateInput').value;
  const guests = document.getElementById('guestsInput').value;

  if (!name || !email || !date || !guests) {
    feedback.textContent = 'Please fill in all required fields.';
    feedback.className = 'form-feedback error';
    return;
  }

  feedback.textContent = `Thank you, ${name}! Your reservation on ${date} for ${guests} guest(s) is confirmed. 🎉`;
  feedback.className = 'form-feedback success';
  this.reset();
});

// ── Mobile nav toggle ──────────────────────────────────────────────
document.getElementById('navToggle').addEventListener('click', () => {
  document.querySelector('.nav-links').classList.toggle('open');
});

// Close mobile menu when a link is clicked
document.querySelectorAll('.nav-links a').forEach(link => {
  link.addEventListener('click', () => {
    document.querySelector('.nav-links').classList.remove('open');
  });
});

// ── Footer year ────────────────────────────────────────────────────
document.getElementById('year').textContent = new Date().getFullYear();

// ── Initial render ─────────────────────────────────────────────────
renderMenu();
