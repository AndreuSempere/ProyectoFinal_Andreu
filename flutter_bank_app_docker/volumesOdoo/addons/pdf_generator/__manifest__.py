{
    'name': 'PDF Generator',
    'version': '1.0',
    'category': 'Tools',
    'summary': 'Generate PDF files from templates',
    'description': 'A module to create PDFs from dynamic templates with data passed via POST',
    'author': 'Andreu Sempere Mico',
    'website': '',
    'depends': ['base'],
    'data': [
        'security/ir.model.access.csv',
        'views/pdf_generator_form.xml',
    ],
    'application': True,
    'installable': True,
}
