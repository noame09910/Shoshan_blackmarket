document.addEventListener("DOMContentLoaded", () => {
    function ManageAction(action) {
        switch (action) {
            case 'weapons':
                $.post(`https://neon-balckmarket/action`, JSON.stringify({ action: action }));
                break;
            case 'bounty':
                $.post(`https://neon-balckmarket/action`, JSON.stringify({ action: action }));
                break;
            case 'tools':
                $.post(`https://neon-balckmarket/action`, JSON.stringify({ action: action }));
                break;
            case 'repair':
                $.post(`https://neon-balckmarket/action`, JSON.stringify({ action: action }));
                break;
            case 'cops':
                $.post(`https://neon-balckmarket/action`, JSON.stringify({ action: action }));
                break;
            case 'drugs':
                $.post(`https://neon-balckmarket/action`, JSON.stringify({ action: action }));
                break;
            case 'license':
                $.post(`https://neon-balckmarket/action`, JSON.stringify({ action: action }));
                break;
            case 'zain':
                $.post(`https://neon-balckmarket/action`, JSON.stringify({ action: action }));
                break;
            case 'rampage':
                $.post(`https://neon-balckmarket/action`, JSON.stringify({ action: action }));
                break;
            case 'money_deposit':
                $.post(`https://neon-balckmarket/action`, JSON.stringify({ action: action }));
                break;
            default:
                break;
        }
    }

    const gridItems = document.querySelectorAll('.grid-item');

    gridItems.forEach((item) => {
        item.addEventListener('click', () => {
            const itemId = item.dataset.id
            ManageAction(itemId)
        })
    });

    window.addEventListener("message", (event) => {
        const data = event.data;
    
        if (data.action === "showUI") {
            toggleUI(true);
        } else if(data.action === 'hideUI'){
            toggleUI(false)
        }
    });

    document.addEventListener("keydown", (event) => {
        if (event.key === "Escape") {
            toggleUI(false);
        }
    });

    const copsItem = document.querySelector('.grid-item[data-id="cops"]');

    const tooltip = document.createElement('div');
    tooltip.classList.add('tooltip');
    tooltip.innerText = "₪פעולה זו עולה 8,000";
    tooltip.id = "coptip"

    document.body.appendChild(tooltip);

    
    copsItem.addEventListener('mouseenter', (e) => {
        const rect = copsItem.getBoundingClientRect();
        tooltip.style.left = `${rect.left + rect.width / 2}px`;
        tooltip.style.top = `${rect.top + 25}px`;
        tooltip.style.opacity = '1';
        tooltip.style.visibility = 'visible';
    });

    copsItem.addEventListener('mouseleave', () => {
        tooltip.style.opacity = '0';
        tooltip.style.visibility = 'hidden';
    });

    function toggleUI(show) {    
        if (show) {
            $(".black-market-container").fadeIn(300);
        } else {
            $(".black-market-container").fadeOut(300);
            $.post("https://neon-balckmarket/close")
            tooltip.style.opacity = '0';
            tooltip.style.visibility = 'hidden';
        }
    }
});
