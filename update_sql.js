const fs = require('fs');
const files = ['f:/qlyphongtro/sql/db.sql', 'f:/qlyphongtro/sql/schema.sql'];

files.forEach(file => {
    if (!fs.existsSync(file)) return;
    let content = fs.readFileSync(file, 'utf-8');
    if (!content.includes('signed_pdf_url text')) {
        content = content.replace(
            'locked_at timestamp with time zone',
            'locked_at timestamp with time zone,\n    signed_pdf_url text,\n    tenant_signed_at timestamp with time zone,\n    landlord_signed_at timestamp with time zone,\n    signature_status character varying(50) DEFAULT \'UNSIGNED\'::character varying NOT NULL'
        );
        fs.writeFileSync(file, content);
        console.log('Updated ' + file);
    } else {
        console.log('Already updated ' + file);
    }
});
