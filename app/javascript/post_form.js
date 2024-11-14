// app/javascript/post_form.js

document.addEventListener("turbo:load", () => {
  const standardTagsContainer = document.getElementById("standard-tags-container");
  const categoryTagsContainer = document.getElementById("category-tags-container");
  const selectedTagsContainer = document.getElementById("selected-tags-container");
  const selectedTagsCount = document.getElementById("selected-tags-count");
  const tagSelectionFeedback = document.getElementById("tag-selection-feedback");
  const categoryContainer = document.getElementById("category-container");
  const selectedCategoryInput = document.getElementById("selected-category-id");
  let selectedCategoryId = selectedCategoryInput.value;

  // 初期選択されているタグIDを配列として取得（文字列として）
  let selectedTagIds = Array.from(selectedTagsContainer.querySelectorAll("input[name='post[tag_ids][]']")).map(input => input.value.toString());

  // タグボタンのクリックイベントをタグコンテナに設定
  [standardTagsContainer, categoryTagsContainer].forEach(container => {
    if (container) {
      container.addEventListener("click", (event) => {
        if (event.target.classList.contains("tag-button")) {
          toggleTagSelection(event.target);
        }
      });
    }
  });

  // カテゴリーボタンのクリックイベントをカテゴリーコンテナに設定
  if (categoryContainer) {
    categoryContainer.addEventListener("click", (event) => {
      if (event.target.classList.contains("category-button")) {
        selectCategory(event.target);
      }
    });
  }

  // タグの選択状態を切り替える関数
  function toggleTagSelection(tagButton) {
    const tagId = tagButton.dataset.tagId.toString();

    if (selectedTagIds.includes(tagId)) {
      // タグを選択解除
      selectedTagIds = selectedTagIds.filter(id => id !== tagId);
      updateTagButtonState(tagButton, false);
    } else {
      if (selectedTagIds.length >= 3) {
        // 最大選択数に達した場合のフィードバック（UI上に表示）
        showFeedback("タグは最大3つまで選択できます。");
        return;
      }
      // タグを選択
      selectedTagIds.push(tagId);
      updateTagButtonState(tagButton, true);
    }

    // 隠しフィールドを更新
    updateSelectedTags();
    // 選択数を更新
    updateCount();
    // フィードバックメッセージをクリア
    hideFeedback();
  }

  // タグボタンの状態を更新する関数
  function updateTagButtonState(tagButton, isSelected) {
    if (isSelected) {
      tagButton.classList.add("badge-primary");
      tagButton.classList.remove("badge-neutral");
      tagButton.setAttribute("aria-pressed", "true");
    } else {
      tagButton.classList.remove("badge-primary");
      tagButton.classList.add("badge-neutral");
      tagButton.setAttribute("aria-pressed", "false");
    }
  }

  // 隠しフィールドを更新する関数
  function updateSelectedTags() {
    // 既存のhidden fieldsをクリア
    selectedTagsContainer.innerHTML = "";

    // 選択されたタグIDをhidden fieldとして追加
    selectedTagIds.forEach(id => {
      const input = document.createElement("input");
      input.type = "hidden";
      input.name = "post[tag_ids][]";
      input.value = id;
      selectedTagsContainer.appendChild(input);
    });
  }

  // 選択数を更新する関数
  function updateCount() {
    if (selectedTagsCount) {
      selectedTagsCount.textContent = selectedTagIds.length;
    }
  }

  // フィードバックメッセージを表示する関数
  function showFeedback(message) {
    if (tagSelectionFeedback) {
      tagSelectionFeedback.textContent = message;
      tagSelectionFeedback.classList.remove("hidden");
    }
  }

  // フィードバックメッセージを非表示にする関数
  function hideFeedback() {
    if (tagSelectionFeedback) {
      tagSelectionFeedback.textContent = "";
      tagSelectionFeedback.classList.add("hidden");
    }
  }

  // タグボタンの初期選択状態を反映する関数
  function initializeTagButtons() {
    document.querySelectorAll(".tag-button").forEach(button => {
      const tagId = button.dataset.tagId.toString();
      if (selectedTagIds.includes(tagId)) {
        updateTagButtonState(button, true);
      } else {
        updateTagButtonState(button, false);
      }
    });
  }

  // カテゴリーボタンの選択状態を切り替える関数
  function selectCategory(categoryButton) {
    const categoryId = categoryButton.dataset.categoryId;

    // 選択状態を更新
    selectedCategoryId = categoryId;
    selectedCategoryInput.value = categoryId;

    // 全てのカテゴリーボタンの状態をリセット
    document.querySelectorAll(".category-button").forEach(btn => {
      updateCategoryButtonState(btn, false);
    });

    // 選択されたカテゴリーボタンの状態を更新
    updateCategoryButtonState(categoryButton, true);

    // カテゴリー専用タグを読み込む
    loadCategorySpecificTags(categoryId);
  }

  // カテゴリーボタンの状態を更新する関数
  function updateCategoryButtonState(categoryButton, isSelected) {
    if (isSelected) {
      categoryButton.classList.add("badge-primary");
      categoryButton.classList.remove("badge-neutral");
    } else {
      categoryButton.classList.remove("badge-primary");
      categoryButton.classList.add("badge-neutral");
    }
  }

  // カテゴリー専用タグを取得して表示する関数
  async function loadCategorySpecificTags(categoryId) {
    try {
      // サーバーから該当カテゴリーのタグを取得
      const response = await fetch(`/tags/by_category?category_id=${categoryId}`);
      if (!response.ok) {
        throw new Error("ネットワーク応答が正常ではありません");
      }
      const tags = await response.json(); // `TagsController#by_category` が配列を返すと仮定

      // 既存のカテゴリー専用タグをクリアし、選択解除
      resetCategorySpecificTags();

      // 新しいカテゴリー専用タグを表示
      tags.forEach(tag => {
        const tagButton = document.createElement("span");
        tagButton.textContent = `#${tag.name}`;
        tagButton.className = "tag-button carousel-item badge badge-neutral cursor-pointer select-none";
        tagButton.dataset.tagId = String(tag.id);
        tagButton.dataset.tagType = tag.tag_type;

        // 選択状態の反映
        if (selectedTagIds.includes(tagButton.dataset.tagId)) {
          updateTagButtonState(tagButton, true);
        }

        // タグボタンを追加
        categoryTagsContainer.appendChild(tagButton);
      });

      // 選択数を更新
      updateCount();
      // フィードバックメッセージをクリア
      hideFeedback();
    } catch (error) {
      console.error("カテゴリー専用タグの取得に失敗しました:", error);
      // フィードバックメッセージを表示
      showFeedback("タグの取得に失敗しました。もう一度試してください。");
    }
  }

  // カテゴリー変更時にカテゴリー専用タグをリセットする関数
  function resetCategorySpecificTags() {
    // カテゴリー専用タグコンテナ内のタグボタンを全て削除
    const categoryTagButtons = categoryTagsContainer.querySelectorAll(".tag-button");
    categoryTagButtons.forEach(tagButton => {
      // 選択されている場合は選択解除
      const tagId = tagButton.dataset.tagId.toString();
      if (selectedTagIds.includes(tagId)) {
        selectedTagIds = selectedTagIds.filter(id => id !== tagId);
        // 隠しフィールドを削除
        const hiddenField = selectedTagsContainer.querySelector(`input[value="${tagId}"]`);
        if (hiddenField) {
          hiddenField.remove();
        }
      }
      // タグボタンを削除
      tagButton.remove();
    });

    // 選択数を更新
    updateCount();
    // フィードバックメッセージをクリア
    hideFeedback();
  }

  // タグボタンの初期選択状態を反映する関数
  function initializeTagButtons() {
    document.querySelectorAll(".tag-button").forEach(button => {
      const tagId = button.dataset.tagId.toString();
      if (selectedTagIds.includes(tagId)) {
        updateTagButtonState(button, true);
      } else {
        updateTagButtonState(button, false);
      }
    });
  }

  // カテゴリーボタンの初期選択状態を反映する関数
  function initializeCategoryButtons() {
    document.querySelectorAll(".category-button").forEach(button => {
      const categoryId = button.dataset.categoryId;
      if (categoryId === selectedCategoryId) {
        updateCategoryButtonState(button, true);
      } else {
        updateCategoryButtonState(button, false);
      }
    });
  }

  // 初期タグボタンの設定
  initializeTagButtons();
  // 初期カテゴリーボタンの設定
  initializeCategoryButtons();
  // 初期選択数の更新
  updateCount();

  // ページロード時に、選択されているカテゴリーの専用タグを表示
  if (selectedCategoryId) {
    loadCategorySpecificTags(selectedCategoryId);
  }
});
