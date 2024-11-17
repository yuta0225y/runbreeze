document.addEventListener("turbo:load", () => {
  const standardTagsContainer = document.getElementById("standard-tags-container");
  const categoryTagsContainer = document.getElementById("category-tags-container");
  const selectedTagsContainer = document.getElementById("selected-tags-container");
  const selectedTagsCount = document.getElementById("selected-tags-count");
  const tagSelectionFeedback = document.getElementById("tag-selection-feedback");
  const categoryContainer = document.getElementById("category-container");
  const selectedCategoryInput = document.getElementById("selected-category-id");
  
  if (!selectedCategoryInput) {
    console.error('Element with ID "selected-category-id" not found.');
    return; // 必要に応じて早期リターン
  }
  
  let selectedCategoryId = selectedCategoryInput.value;

  if (!selectedTagsContainer) {
    console.error('Element with ID "selected-tags-container" not found.');
    return;
  }

  // 初期選択されているタグIDを配列として取得（文字列として）
  let selectedTagIds = Array.from(selectedTagsContainer.querySelectorAll("input[name='post[tag_ids][]']")).map(input => input.value.toString());

  // 残りのコードも同様に、各コンテナが存在するか確認してからイベントリスナーを設定
  [standardTagsContainer, categoryTagsContainer].forEach(container => {
    if (container) {
      container.addEventListener("click", (event) => {
        if (event.target.classList.contains("tag-button")) {
          toggleTagSelection(event.target);
        }
      });
    } else {
      console.warn('One of the tag containers is not found.');
    }
  });

  if (categoryContainer) {
    categoryContainer.addEventListener("click", (event) => {
      if (event.target.classList.contains("category-button")) {
        selectCategory(event.target);
      }
    });
  } else {
    console.warn('Category container not found.');
  }

  // 以下の関数内でも同様に要素の存在を確認
  // 例: loadCategorySpecificTags 内の categoryTagsContainer
  async function loadCategorySpecificTags(categoryId) {
    if (!categoryTagsContainer) {
      console.error('Category tags container not found.');
      showFeedback("タグコンテナが見つかりませんでした。");
      return;
    }

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

      // タグボタンのイベントリスナーを再設定（新たに追加されたタグにも対応）
      categoryTagsContainer.addEventListener("click", (event) => {
        if (event.target.classList.contains("tag-button")) {
          toggleTagSelection(event.target);
        }
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

  // 他の関数内でも同様のチェックを追加
  // 例: resetCategorySpecificTags
  function resetCategorySpecificTags() {
    if (!categoryTagsContainer) {
      console.error('Category tags container not found.');
      return;
    }

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

  // その他の初期化関数も同様にチェックを追加
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
