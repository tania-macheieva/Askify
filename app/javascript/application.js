document.addEventListener("DOMContentLoaded", () => {
	const avatarInput = document.getElementById("avatarInput");
	const avatarPreview = document.getElementById("avatarPreview");

	if (!avatarInput || !avatarPreview) return;

	const avatarContainer = avatarPreview.closest(".avatar-upload-container");
	if (!avatarContainer) {
		console.error("avatar-upload-container not found");
		return;
	}

	function updateAvatarPreview(imageSrc = null) {
		if (imageSrc) {
			avatarPreview.innerHTML = `...`;
			avatarContainer.classList.add("has-image");
		} else {
			avatarPreview.innerHTML = `...`;
			avatarContainer.classList.remove("has-image");
		}

		const newInput = avatarInput.cloneNode(true);
		avatarPreview.appendChild(newInput);

		const currentInput = avatarPreview.querySelector(".avatar-input");
		if (currentInput) {
			currentInput.addEventListener("change", handleFileChange);
		}
	}

	function removeAvatar() {
		avatarInput.value = "";
		let removeInput = document.querySelector(
			'input[name="user[remove_avatar]"]'
		);
		if (!removeInput) {
			removeInput = document.createElement("input");
			removeInput.type = "hidden";
			removeInput.name = "user[remove_avatar]";
			avatarInput.closest("form").appendChild(removeInput);
		}
		removeInput.value = "1";
		updateAvatarPreview();
	}

	function handleFileChange(e) {
		const file = e.target.files[0];
		if (!file) return;

		const removeInput = document.querySelector(
			'input[name="user[remove_avatar]"]'
		);
		if (removeInput) {
			removeInput.remove();
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

	avatarInput.addEventListener("change", handleFileChange);

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

	window.removeAvatar = removeAvatar;
});
