document.addEventListener("DOMContentLoaded", function () {
    const links = document.querySelectorAll(".line-clickable");
    const detailBoxes = document.querySelectorAll(".detail-box");

    links.forEach(link => {
        link.addEventListener("click", function (e) {
            e.preventDefault();
            const targetId = this.dataset.target;

            // Ẩn toàn bộ box
            detailBoxes.forEach(box => box.style.display = "none");

            // Hiện box tương ứng
            const targetBox = document.getElementById(targetId);
            if (targetBox) targetBox.style.display = "block";
        });
    });
});
