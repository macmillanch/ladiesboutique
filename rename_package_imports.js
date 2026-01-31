const fs = require('fs');
const path = require('path');

const dirs = ['lib', 'test'];

function walk(dir) {
    if (!fs.existsSync(dir)) return;
    const list = fs.readdirSync(dir);
    list.forEach(file => {
        const filePath = path.join(dir, file);
        const stat = fs.statSync(filePath);
        if (stat && stat.isDirectory()) {
            walk(filePath);
        } else {
            if (filePath.endsWith('.dart')) {
                let content = fs.readFileSync(filePath, 'utf8');
                if (content.includes('package:ladies_boutique/')) {
                    content = content.replace(/package:ladies_boutique\//g, 'package:rkj_fashions/');
                    fs.writeFileSync(filePath, content);
                    console.log(`Updated ${filePath}`);
                }
            }
        }
    });
}

dirs.forEach(d => walk(d));
console.log("Renaming complete.");
