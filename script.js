document.addEventListener("DOMContentLoaded", function () {
  // Image Slider
  const slides = document.querySelectorAll(".slide");
  const dots = document.querySelectorAll(".dot");
  const prevBtn = document.querySelector(".prev");
  const nextBtn = document.querySelector(".next");
  let currentSlide = 0;
  let slideInterval;

  function showSlide(index) {
    // Hide all slides
    slides.forEach((slide) => {
      slide.style.display = "none";
    });

    // Remove active class from all dots
    dots.forEach((dot) => {
      dot.classList.remove("active");
    });

    // Show the current slide and activate the corresponding dot
    slides[index].style.display = "block";
    dots[index].classList.add("active");
    currentSlide = index;
  }

  function nextSlide() {
    currentSlide = (currentSlide + 1) % slides.length;
    showSlide(currentSlide);
  }

  function prevSlide() {
    currentSlide = (currentSlide - 1 + slides.length) % slides.length;
    showSlide(currentSlide);
  }

  // Initialize slider
  showSlide(0);

  // Start automatic slideshow
  function startSlideshow() {
    slideInterval = setInterval(nextSlide, 5000);
  }

  function stopSlideshow() {
    clearInterval(slideInterval);
  }

  startSlideshow();

  // Event listeners for slider controls
  prevBtn.addEventListener("click", function () {
    prevSlide();
    stopSlideshow();
    startSlideshow();
  });

  nextBtn.addEventListener("click", function () {
    nextSlide();
    stopSlideshow();
    startSlideshow();
  });

  dots.forEach((dot) => {
    dot.addEventListener("click", function () {
      const slideIndex = parseInt(this.getAttribute("data-index"));
      showSlide(slideIndex);
      stopSlideshow();
      startSlideshow();
    });
  });

  // Login and Signup Overlay Forms
  const loginBtn = document.getElementById("login-btn");
  const signupBtn = document.getElementById("signup-btn");
  const loginOverlay = document.getElementById("login-overlay");
  const signupOverlay = document.getElementById("signup-overlay");
  const closeBtns = document.querySelectorAll(".close-btn");
  const switchToSignup = document.getElementById("switch-to-signup");
  const switchToLogin = document.getElementById("switch-to-login");

  function openOverlay(overlay) {
    overlay.classList.add("active");
    document.body.style.overflow = "hidden";
  }

  function closeOverlay(overlay) {
    overlay.classList.remove("active");
    document.body.style.overflow = "";
  }

  loginBtn.addEventListener("click", function () {
    openOverlay(loginOverlay);
  });

  signupBtn.addEventListener("click", function () {
    openOverlay(signupOverlay);
  });

  closeBtns.forEach((btn) => {
    btn.addEventListener("click", function () {
      closeOverlay(this.closest(".overlay"));
    });
  });

  switchToSignup.addEventListener("click", function (e) {
    e.preventDefault();
    closeOverlay(loginOverlay);
    openOverlay(signupOverlay);
  });

  switchToLogin.addEventListener("click", function (e) {
    e.preventDefault();
    closeOverlay(signupOverlay);
    openOverlay(loginOverlay);
  });

  // Close overlay when clicking outside the content
  document.addEventListener("click", function (e) {
    if (e.target.classList.contains("overlay")) {
      closeOverlay(e.target);
    }
  });

  // Product Quick View Modal
  const quickViewBtns = document.querySelectorAll(".quick-view-btn");
  const productModal = document.getElementById("product-modal");
  const closeModal = document.querySelector(".close-modal");
  const modalMainImage = document.getElementById("modal-main-image");
  const modalProductTitle = document.getElementById("modal-product-title");
  const modalProductPrice = document.getElementById("modal-product-price");
  const modalProductDescription = document.getElementById(
    "modal-product-description"
  );
  const modalAddToCart = document.getElementById("modal-add-to-cart");
  const thumbnails = document.querySelectorAll(".thumbnail");

  // Product data (in a real application, this would come from a database)
  const products = {
    1: {
      title: "Slim Fit Cotton Shirt",
      price: "$49.99",
      description:
        "This premium slim-fit shirt is crafted from high-quality cotton fabric that offers exceptional comfort and breathability. The modern cut provides a sleek silhouette while maintaining comfort throughout the day. Perfect for both casual and formal occasions.",
      mainImage: "images/product1.jpg",
      thumbnails: [
        "images/product1.jpg",
        "images/product1-2.jpg",
        "images/product1-3.jpg",
      ],
    },
    2: {
      title: "Premium Cotton T-Shirt",
      price: "$29.99",
      description:
        "Our premium cotton t-shirt combines style and comfort with its soft, breathable fabric and modern fit. This versatile piece is perfect for casual outings or relaxed office environments. The durable construction ensures it will remain a staple in your wardrobe for years to come.",
      mainImage: "images/product2.jpg",
      thumbnails: [
        "images/product2.jpg",
        "images/product2-2.jpg",
        "images/product2-3.jpg",
      ],
    },
    3: {
      title: "Slim Fit Denim Jeans",
      price: "$59.99",
      description:
        "These slim-fit denim jeans offer the perfect balance of style and comfort. Made from high-quality denim with a touch of stretch for enhanced mobility. The classic five-pocket design and versatile wash make these jeans an essential addition to any wardrobe.",
      mainImage: "images/product3.jpg",
      thumbnails: [
        "images/product3.jpg",
        "images/product3-2.jpg",
        "images/product3-3.jpg",
      ],
    },
    4: {
      title: "Classic Fit Formal Suit",
      price: "$199.99",
      description:
        "Our classic fit formal suit is tailored to perfection using premium fabrics that ensure both comfort and elegance. The timeless design features a two-button jacket with notch lapels and flat-front trousers. Ideal for professional settings and special occasions alike.",
      mainImage: "images/product4.jpg",
      thumbnails: [
        "images/product4.jpg",
        "images/product4-2.jpg",
        "images/product4-3.jpg",
      ],
    },
  };

  function openModal(productId) {
    const product = products[productId];

    if (product) {
      modalMainImage.src = product.mainImage;
      modalProductTitle.textContent = product.title;
      modalProductPrice.textContent = product.price;
      modalProductDescription.textContent = product.description;

      // Set thumbnails
      const thumbnailImages = document.querySelectorAll(
        ".thumbnail-images .thumbnail"
      );
      for (let i = 0; i < thumbnailImages.length; i++) {
        if (product.thumbnails[i]) {
          thumbnailImages[i].src = product.thumbnails[i];
          thumbnailImages[i].style.display = "block";
        } else {
          thumbnailImages[i].style.display = "none";
        }
      }

      modalAddToCart.setAttribute("data-product-id", productId);
      productModal.classList.add("active");
      document.body.style.overflow = "hidden";
    }
  }

  function closeProductModal() {
    productModal.classList.remove("active");
    document.body.style.overflow = "";
  }

  quickViewBtns.forEach((btn) => {
    btn.addEventListener("click", function () {
      const productId = this.getAttribute("data-product-id");
      openModal(productId);
    });
  });

  closeModal.addEventListener("click", closeProductModal);

  // Close modal when clicking outside the content
  productModal.addEventListener("click", function (e) {
    if (e.target === productModal) {
      closeProductModal();
    }
  });

  // Thumbnail click event
  thumbnails.forEach((thumbnail) => {
    thumbnail.addEventListener("click", function () {
      modalMainImage.src = this.src;
    });
  });

  // Quantity buttons
  const minusBtn = document.querySelector(".quantity-btn.minus");
  const plusBtn = document.querySelector(".quantity-btn.plus");
  const quantityInput = document.querySelector(".quantity-input input");

  minusBtn.addEventListener("click", function () {
    let value = parseInt(quantityInput.value);
    if (value > 1) {
      quantityInput.value = value - 1;
    }
  });

  plusBtn.addEventListener("click", function () {
    let value = parseInt(quantityInput.value);
    if (value < 10) {
      quantityInput.value = value + 1;
    }
  });

  // Size and color selection
  const sizeBtns = document.querySelectorAll(".size-btn");
  const colorBtns = document.querySelectorAll(".color-btn");

  sizeBtns.forEach((btn) => {
    btn.addEventListener("click", function () {
      sizeBtns.forEach((b) => b.classList.remove("active"));
      this.classList.add("active");
    });
  });

  colorBtns.forEach((btn) => {
    btn.addEventListener("click", function () {
      colorBtns.forEach((b) => b.classList.remove("active"));
      this.classList.add("active");
    });
  });

  // Add to cart functionality
  const addToCartBtns = document.querySelectorAll(".add-to-cart-btn");
  const cartCount = document.querySelector(".cart-count");
  let cartItems = [];

  function updateCartCount() {
    cartCount.textContent = cartItems.length;
  }

  addToCartBtns.forEach((btn) => {
    btn.addEventListener("click", function () {
      const productId = this.getAttribute("data-product-id");
      const product = products[productId];

      if (product) {
        // In a real application, you would also include quantity, size, color, etc.
        cartItems.push({
          id: productId,
          title: product.title,
          price: product.price,
          image: product.mainImage,
          quantity: 1,
        });

        updateCartCount();

        // Show a confirmation message
        alert(`${product.title} has been added to your cart!`);

        // Close modal if open
        if (productModal.classList.contains("active")) {
          closeProductModal();
        }

        // In a real application, you would save the cart to localStorage or send to server
        localStorage.setItem("cartItems", JSON.stringify(cartItems));
      }
    });
  });

  // Load cart from localStorage on page load
  if (localStorage.getItem("cartItems")) {
    cartItems = JSON.parse(localStorage.getItem("cartItems"));
    updateCartCount();
  }
});
