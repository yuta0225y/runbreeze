// app/javascript/post_form.js

document.addEventListener("turbo:load", () => {
  const categoryRadios = document.querySelectorAll(".category-radio");
  const categoryTagsContainer = document.getElementById("category-tags-container");
  const selectedTagsContainer = document.getElementById("selected-tags-container");

  let selectedTagIds = [];

  // タグの選択状態を切り替える関数
  function toggleTagSelection(tagButton) {
    const tagId = tagButton.dataset.tagId;

    if (selectedTagIds.includes(tagId)) {
      // タグを選択解除
      selectedTagIds = selectedTagIds.filter(id => id !== tagId);
      tagButton.classList.remove("bg-blue-500", "text-white", "border-transparent");
      tagButton.classList.add("bg-transparent");
    } else if (selectedTagIds.length < 3) { // 最大3つまで
      // タグを選択
      selectedTagIds.push(tagId);
      tagButton.classList.add("bg-blue-500", "text-white", "border-transparent");
      tagButton.classList.remove("bg-transparent");
    } else {
      // 最大選択数に達した場合のフィードバック（任意）
      alert("タグは最大3つまで選択できます。");
      return;
    }

    // 隠しフィールドを更新
    updateSelectedTags();
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

  // 標準タグにクリックイベントを追加
  document.querySelectorAll(".tag-button").forEach(button => {
    button.addEventListener("click", () => toggleTagSelection(button));
  });

  // カテゴリー選択時に専用タグを動的に表示
  categoryRadios.forEach(radio => {
    radio.addEventListener("change", async () => {
      const categoryId = radio.dataset.categoryId;

      try {
        // サーバーから該当カテゴリーのタグを取得
        const response = await fetch(`/tags/by_category?category_id=${categoryId}`);
        if (!response.ok) {
          throw new Error("ネットワーク応答が正常ではありません");
        }
        const tags = await response.json();

        // 既存のカテゴリー専用タグをクリア
        categoryTagsContainer.innerHTML = "";

        // 新しいカテゴリー専用タグを表示
        tags.forEach(tag => {
          const tagButton = document.createElement("span");
          tagButton.textContent = `#${tag.name}`;
          tagButton.className = "tag-button carousel-item px-3 py-1 bg-transparent text-gray-500 border border-gray-300 rounded-full cursor-pointer transition duration-200 ease-in-out";
          tagButton.dataset.tagId = tag.id;

          // カテゴリー専用タグのクリックで色を変える
          tagButton.addEventListener("click", () => toggleTagSelection(tagButton));

          categoryTagsContainer.appendChild(tagButton);
        });
      } catch (error) {
        console.error("カテゴリー専用タグの取得に失敗しました:", error);
        // 必要に応じてユーザーにエラーメッセージを表示
      }
    });
  });
});
