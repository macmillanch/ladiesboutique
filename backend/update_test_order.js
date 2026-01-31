const db = require('./db');

(async () => {
    try {
        console.log("Connecting to DB...");
        // Force init if needed
        // await db.initDb(); 

        // Find latest order
        const res = await db.query('SELECT id FROM orders ORDER BY created_at DESC LIMIT 1');

        if (res.rows.length === 0) {
            console.log("No orders found. Creating dummy...");
            // Assume user ID 1 exists, if not we might fail constraint. 
            // We'll try to find a user first.
            const userRes = await db.query('SELECT id FROM users LIMIT 1');
            let userId = 1;
            if (userRes.rows.length > 0) userId = userRes.rows[0].id;

            await db.query(`INSERT INTO orders (user_id, total_amount, items, status, tracking_id, payment_method) 
                            VALUES ($1, 1500.00, '[]', 'Shipped', 'EM123456789IN', 'COD')`, [userId]);
            console.log("Created dummy order for User " + userId + " with tracking ID.");
        } else {
            const id = res.rows[0].id;
            await db.query("UPDATE orders SET status = 'Shipped', tracking_id = 'EM123456789IN' WHERE id = $1", [id]);
            console.log(`Updated Order ID ${id} with tracking ID EM123456789IN`);
        }
    } catch (e) {
        console.error("Error:", e);
    } finally {
        // process.exit(0); // db pool might hang
    }
})();
