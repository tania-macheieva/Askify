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
	let removeInput = document.querySelector(
		`input[name="${REMOVE_INPUT_NAME}"]`
	);

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

document.addEventListener("DOMContentLoaded", () => {
	const input = document.getElementById("avatar-upload");
	const filenameSpan = document.getElementById("avatar-filename");

	input.addEventListener("change", () => {
		filenameSpan.textContent = input.files[0]?.name || "No file chosen";
	});
});

document.addEventListener("DOMContentLoaded", () => {
	document
		.querySelectorAll('[data-action="toggle-answer-form"]')
		.forEach(button => {
			button.addEventListener("click", () => {
				const questionId = button.dataset.questionId;
				const form = document.getElementById(
					`answer-form-${questionId}`
				);
				form.classList.toggle("hidden");
			});
		});
});

document.addEventListener("DOMContentLoaded", function () {
	document.addEventListener("click", function (e) {
		if (e.target.closest(".show-answer-form-btn")) {
			e.preventDefault();
			const showBtn = e.target.closest(".show-answer-form-btn");
			const questionId = showBtn.dataset.questionId;
			const answerForm = document.querySelector(
				`#answer-form-${questionId}`
			);

			if (answerForm) {
				showBtn.style.display = "none";
				answerForm.style.display = "block";
				const textarea = answerForm.querySelector("textarea");
				if (textarea) {
					setTimeout(() => textarea.focus(), 100);
				}
			}
		}

		if (e.target.closest(".cancel-answer-btn")) {
			e.preventDefault();
			const button = e.target.closest(".cancel-answer-btn");
			const questionId = button.dataset.questionId;
			const answerForm = document.querySelector(
				`#answer-form-${questionId}`
			);
			const showButton = document.querySelector(
				`[data-question-id="${questionId}"].show-answer-form-btn`
			);

			if (answerForm && showButton) {
				answerForm.style.display = "none";
				showButton.style.display = "inline-block";

				const textarea = answerForm.querySelector("textarea");
				if (textarea) {
					textarea.value = "";
				}
			}
		}

		if (e.target.closest(".edit-answer-btn")) {
			e.preventDefault();
			const button = e.target.closest(".edit-answer-btn");
			const questionId = button.dataset.questionId;

			const answerContainer = document.querySelector(
				`#question-${questionId} .answer-container`
			);
			const editForm = document.querySelector(
				`#edit-answer-form-${questionId}`
			);

			if (answerContainer && editForm) {
				const answerText = answerContainer.querySelector(".text-dark");
				const questionBtns =
					answerContainer.querySelector(".question-btns");

				if (answerText) answerText.style.display = "none";
				if (questionBtns) questionBtns.style.display = "none";

				editForm.style.display = "block";
				const textarea = editForm.querySelector("textarea");
				if (textarea) {
					setTimeout(() => textarea.focus(), 100);
				}
			}
		}

		if (e.target.closest(".cancel-edit-btn")) {
			e.preventDefault();
			const button = e.target.closest(".cancel-edit-btn");
			const questionId = button.dataset.questionId;
			const answerContainer = document.querySelector(
				`#question-${questionId} .answer-container`
			);
			const editForm = document.querySelector(
				`#edit-answer-form-${questionId}`
			);

			if (answerContainer && editForm) {
				const answerText = answerContainer.querySelector(".text-dark");
				const questionBtns =
					answerContainer.querySelector(".question-btns");

				if (answerText) answerText.style.display = "block";
				if (questionBtns) questionBtns.style.display = "flex";

				editForm.style.display = "none";
			}
		}
	});
});
