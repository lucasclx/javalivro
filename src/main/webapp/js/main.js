import Notifications from './notifications.js';
import CartActions from './cart.js';
import Search from './search.js';

document.addEventListener('DOMContentLoaded', () => {
    const notifications = new Notifications();
    const cart = new CartActions(notifications);
    new Search(cart, notifications);
});
