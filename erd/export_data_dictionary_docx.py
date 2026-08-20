import os
import sys
import docx
from docx import Document
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT, WD_ALIGN_VERTICAL
from docx.oxml import OxmlElement, parse_xml
from docx.oxml.ns import nsdecls, qn

if sys.stdout.encoding != 'utf-8':
    sys.stdout.reconfigure(encoding='utf-8')

# Read markdown content
MD_FILE = r"C:\Users\Admin\.gemini\antigravity\brain\49e3bf63-c309-461b-afc0-44cf1588ed00\data_dictionary_fashion_vest.md"
with open(MD_FILE, "r", encoding="utf-8") as f:
    text = f.read()

doc = Document()

# Page Setup
for section in doc.sections:
    section.top_margin = Inches(0.75)
    section.bottom_margin = Inches(0.75)
    section.left_margin = Inches(0.75)
    section.right_margin = Inches(0.75)

# Set base style to Times New Roman 12pt
style = doc.styles['Normal']
font = style.font
font.name = 'Times New Roman'
font.size = Pt(11)
font.color.rgb = RGBColor(33, 37, 41)

def set_cell_background(cell, fill_hex):
    tcPr = cell._element.get_or_add_tcPr()
    shd = parse_xml(f'<w:shd {nsdecls("w")} w:fill="{fill_hex}"/>')
    tcPr.append(shd)

def set_cell_margins(cell, top=100, bottom=100, left=150, right=150):
    tcPr = cell._element.get_or_add_tcPr()
    tcMar = parse_xml(f'''
        <w:tcMar {nsdecls("w")}>
            <w:top w:w="{top}" w:type="dxa"/>
            <w:bottom w:w="{bottom}" w:type="dxa"/>
            <w:left w:w="{left}" w:type="dxa"/>
            <w:right w:w="{right}" w:type="dxa"/>
        </w:tcMar>
    ''')
    tcPr.append(tcMar)

def set_table_borders(table):
    tblPr = table._element.xpath('w:tblPr')
    if tblPr:
        borders = parse_xml(f'''
            <w:tblBorders {nsdecls("w")}>
                <w:top w:val="single" w:sz="6" w:space="0" w:color="CCCCCC"/>
                <w:bottom w:val="single" w:sz="6" w:space="0" w:color="CCCCCC"/>
                <w:insideH w:val="single" w:sz="4" w:space="0" w:color="E5E7EB"/>
                <w:insideV w:val="none"/>
                <w:left w:val="none"/>
                <w:right w:val="none"/>
            </w:tblBorders>
        ''')
        tblPr[0].append(borders)

# Title
title_p = doc.add_paragraph()
title_p.alignment = WD_ALIGN_PARAGRAPH.CENTER
run = title_p.add_run("TỪ ĐIỂN DỮ LIỆU HỆ THỐNG QUẢN LÝ BÁN ÂU PHỤC & VEST")
run.bold = True
run.font.size = Pt(15)
run.font.color.rgb = RGBColor(15, 23, 42)

sub_p = doc.add_paragraph()
sub_p.alignment = WD_ALIGN_PARAGRAPH.CENTER
run_sub = sub_p.add_run("Mô tả cấu trúc 28 bảng cơ sở dữ liệu (Data Dictionary chuẩn báo cáo tốt nghiệp / đồ án)")
run_sub.italic = True
run_sub.font.size = Pt(10.5)
run_sub.font.color.rgb = RGBColor(100, 116, 139)

doc.add_paragraph()

lines = text.split('\n')
i = 0
while i < len(lines):
    line = lines[i].strip()
    
    if line.startswith('## NHÓM'):
        h1_p = doc.add_paragraph()
        run_h1 = h1_p.add_run(line.replace('##', '').strip())
        run_h1.bold = True
        run_h1.font.size = Pt(13)
        run_h1.font.color.rgb = RGBColor(30, 64, 175)
        h1_p.paragraph_format.space_before = Pt(14)
        h1_p.paragraph_format.space_after = Pt(6)
        i += 1
        continue
        
    if line.startswith('### '):
        h2_p = doc.add_paragraph()
        run_h2 = h2_p.add_run(line.replace('###', '').strip())
        run_h2.bold = True
        run_h2.font.size = Pt(11.5)
        run_h2.font.color.rgb = RGBColor(15, 23, 42)
        h2_p.paragraph_format.space_before = Pt(10)
        h2_p.paragraph_format.space_after = Pt(4)
        i += 1
        continue
        
    if line.startswith('| STT |'):
        # Table parsing
        table_lines = []
        while i < len(lines) and lines[i].strip().startswith('|'):
            table_lines.append(lines[i].strip())
            i += 1
            
        if len(table_lines) >= 3:
            # Parse header
            header_cols = [c.strip() for c in table_lines[0].split('|')[1:-1]]
            # Parse rows
            data_rows = []
            for r in table_lines[2:]:
                cols = [c.strip().replace('`', '') for c in r.split('|')[1:-1]]
                if len(cols) == len(header_cols):
                    data_rows.append(cols)
                    
            table = doc.add_table(rows=len(data_rows) + 1, cols=len(header_cols))
            table.alignment = WD_TABLE_ALIGNMENT.CENTER
            set_table_borders(table)
            
            col_widths = [Inches(0.6), Inches(1.8), Inches(1.3), Inches(2.7), Inches(0.9)]
            
            # Populate header
            for col_idx, h_text in enumerate(header_cols):
                cell = table.cell(0, col_idx)
                cell.text = h_text
                set_cell_background(cell, "F1F5F9")
                set_cell_margins(cell, top=120, bottom=120, left=120, right=120)
                p = cell.paragraphs[0]
                p.alignment = WD_ALIGN_PARAGRAPH.CENTER if col_idx in [0, 4] else WD_ALIGN_PARAGRAPH.LEFT
                for r in p.runs:
                    r.bold = True
                    r.font.size = Pt(10)
                    r.font.color.rgb = RGBColor(30, 41, 59)
                    
            # Populate data rows
            for row_idx, row_data in enumerate(data_rows):
                for col_idx, cell_data in enumerate(row_data):
                    cell = table.cell(row_idx + 1, col_idx)
                    cell.text = cell_data
                    set_cell_margins(cell, top=90, bottom=90, left=120, right=120)
                    p = cell.paragraphs[0]
                    p.alignment = WD_ALIGN_PARAGRAPH.CENTER if col_idx in [0, 4] else WD_ALIGN_PARAGRAPH.LEFT
                    for r in p.runs:
                        r.font.size = Pt(9.5)
                        if col_idx == 1:
                            r.bold = True
                            r.font.color.rgb = RGBColor(15, 23, 42)
                        elif col_idx == 4 and cell_data == 'PK':
                            r.bold = True
                            r.font.color.rgb = RGBColor(220, 38, 38)
                        elif col_idx == 4 and cell_data == 'FK':
                            r.bold = True
                            r.font.color.rgb = RGBColor(37, 99, 235)
                        elif col_idx == 4 and 'Not null' in cell_data:
                            r.font.color.rgb = RGBColor(16, 185, 129)
                        else:
                            r.font.color.rgb = RGBColor(71, 85, 105)
                            
            # Set col widths
            for row in table.rows:
                for idx, width in enumerate(col_widths):
                    row.cells[idx].width = width
                    
            doc.add_paragraph()
        continue
    i += 1

OUTPUT_DOCX = r"C:\Users\Admin\Downloads\Tu_Dien_Du_Lieu_Data_Dictionary_Vest_Fashion.docx"
doc.save(OUTPUT_DOCX)
print(f"Generated Docx successfully: {OUTPUT_DOCX}")
