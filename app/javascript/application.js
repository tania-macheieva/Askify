

document.addEventListener("DOMContentLoaded", () => {
  const button = document.getElementById("copy-email");
  const emailText = document.getElementById("email-text");

  if (button) {
    button.addEventListener("click", () => {
      const email = button.dataset.email;

      navigator.clipboard.writeText(email).then(() => {
        const original = emailText.innerText;
        emailText.innerText = "Copied!";
        setTimeout(() => {
          emailText.innerText = original;
        }, 2000);
      });
    });
  }
});

document.addEventListener('DOMContentLoaded', () => {
  const avatarInput = document.getElementById('avatarInput');
  const avatarPreview = document.getElementById('avatarPreview');
  const avatarContainer = avatarPreview.closest('.avatar-upload-container');

  if (!avatarInput || !avatarPreview) return;

  function updateAvatarPreview(imageSrc = null) {
    if (imageSrc) {
      avatarPreview.innerHTML = `
        <img src="${imageSrc}" alt="Avatar preview" class="avatar-image">
        <div class="avatar-overlay">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"></path>
            <circle cx="12" cy="13" r="4"></circle>
          </svg>
        </div>
      `;
      avatarContainer.classList.add('has-image');
    } else {
      avatarPreview.innerHTML = `
        <div class="avatar-placeholder">
          <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
            <circle cx="12" cy="7" r="4"></circle>
          </svg>
          <span>Upload Photo</span>
        </div>
      `;
      avatarContainer.classList.remove('has-image');
    }
    
    // Додаємо інпут назад
    const newInput = avatarInput.cloneNode(true);
    avatarPreview.appendChild(newInput);
    
    const currentInput = avatarPreview.querySelector('.avatar-input');
    if (currentInput) {
      currentInput.addEventListener('change', handleFileChange);
    }
  }

  function removeAvatar() {
    avatarInput.value = '';
    
    let removeInput = document.querySelector('input[name="user[remove_avatar]"]');
    if (!removeInput) {
      removeInput = document.createElement('input');
      removeInput.type = 'hidden';
      removeInput.name = 'user[remove_avatar]';
      avatarInput.closest('form').appendChild(removeInput);
    }
    removeInput.value = '1';
    
    updateAvatarPreview();
  }

  function handleFileChange(e) {
    const file = e.target.files[0];
    if (!file) return;

    const removeInput = document.querySelector('input[name="user[remove_avatar]"]');
    if (removeInput) {
      removeInput.remove();
    }

    const reader = new FileReader();
    reader.onload = (e) => {
      updateAvatarPreview(e.target.result);
    };
    reader.readAsDataURL(file);
  }

  function resetAvatarPreviewStyle() {
    avatarPreview.style.borderColor = '#ced4da';
    avatarPreview.style.background = '#f9fbfd';
  }

  // Event listeners
  avatarInput.addEventListener('change', handleFileChange);

  avatarPreview.addEventListener('dragover', (e) => {
    e.preventDefault();
    avatarPreview.style.borderColor = '#007bff';
    avatarPreview.style.background = '#f0f8ff';
  });

  avatarPreview.addEventListener('dragleave', (e) => {
    e.preventDefault();
    resetAvatarPreviewStyle();
  });

  avatarPreview.addEventListener('drop', (e) => {
    e.preventDefault();
    const files = e.dataTransfer.files;
    if (files.length > 0) {
      avatarInput.files = files;
      avatarInput.dispatchEvent(new Event('change'));
    }
    resetAvatarPreviewStyle();
  });

  // Глобальна функція для кнопки видалення
  window.removeAvatar = removeAvatar;
});