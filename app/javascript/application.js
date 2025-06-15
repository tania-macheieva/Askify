document.addEventListener("DOMContentLoaded", () => {
	const avatarInput = document.getElementById("avatarInput");
	const avatarPreview = document.getElementById("avatarPreview");

	if (!avatarInput || !avatarPreview) return;

	const avatarContainer = avatarPreview.closest(".avatar-upload-container");
	if (!avatarContainer) {
		console.error("avatar-upload-container not found");
		return;
	}

	const REMOVE_INPUT_NAME = "user[remove_avatar]";
	let removeInput = document.querySelector(`input[name="${REMOVE_INPUT_NAME}"]`);
	
	function updateAvatarPreview(imageSrc = null) {
		avatarPreview.innerHTML = ""; 

		if (imageSrc) {
			const img = document.createElement("img");
			img.src = imageSrc;
			img.alt = "Avatar preview";
			img.classList.add("avatar-image-preview");

			avatarPreview.appendChild(img);
			avatarContainer.classList.add("has-image");
		} else {
			const placeholder = document.createElement("div");
			placeholder.classList.add("avatar-placeholder");
			placeholder.innerText = "No image";

			avatarPreview.appendChild(placeholder);
			avatarContainer.classList.remove("has-image");
		}
	}
	
	function removeAvatar() {
		avatarInput.value = "";

		if (!removeInput) {
			removeInput = document.createElement("input");
			removeInput.type = "hidden";
			removeInput.name = REMOVE_INPUT_NAME;
			removeInput.value = "1";
			avatarInput.closest("form").appendChild(removeInput);
		} else {
			removeInput.value = "1";
		}

		updateAvatarPreview();
	}

	function handleFileChange(e) {
		const file = e.target.files[0];
		if (!file) return;
		
		if (removeInput) {
			removeInput.remove();
			removeInput = null;
		}

		const reader = new FileReader();
		reader.onload = e => {
			updateAvatarPreview(e.target.result);
		};
		reader.readAsDataURL(file);
	}
	
	function resetAvatarPreviewStyle() {
		avatarPreview.style.borderColor = "#ced4da";
		avatarPreview.style.background = "#f9fbfd";
	}

	avatarPreview.addEventListener("dragover", e => {
		e.preventDefault();
		avatarPreview.style.borderColor = "#007bff";
		avatarPreview.style.background = "#f0f8ff";
	});

	avatarPreview.addEventListener("dragleave", e => {
		e.preventDefault();
		resetAvatarPreviewStyle();
	});

	avatarPreview.addEventListener("drop", e => {
		e.preventDefault();
		const files = e.dataTransfer.files;
		if (files.length > 0) {
			avatarInput.files = files;
			avatarInput.dispatchEvent(new Event("change"));
		}
		resetAvatarPreviewStyle();
	});

	avatarInput.addEventListener("change", handleFileChange);

	window.removeAvatar = removeAvatar;
});
