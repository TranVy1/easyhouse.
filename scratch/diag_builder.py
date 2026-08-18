import os
import html
import xml.etree.ElementTree as ET

class SequenceDiagramBuilder:
    def __init__(self, diag_id, name, width=1600, height=1200):
        self.diag_id = diag_id
        self.name = name
        self.width = width
        self.height = height
        self.cells = []
        self.cell_counter = 1

    def _next_id(self, prefix="cell"):
        self.cell_counter += 1
        return f"{prefix}_{self.cell_counter}"

    def add_title_header(self, title, subtitle, tag_text="EASYHOUSE SYSTEM"):
        cid = self._next_id("title")
        val = f"""<div style="font-family:Segoe UI,sans-serif;">
  <div style="font-size:11px;font-weight:bold;color:#0288D1;letter-spacing:1.5px;text-transform:uppercase;margin-bottom:4px;">{html.escape(tag_text)}</div>
  <div style="font-size:20px;font-weight:bold;color:#1A237E;margin-bottom:4px;">{html.escape(title)}</div>
  <div style="font-size:12px;color:#546E7A;line-height:1.4;">{html.escape(subtitle)}</div>
</div>"""
        self.cells.append(f"""<mxCell id="{cid}" value="{html.escape(val)}" style="shape=rectangle;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#CFD8DC;strokeWidth=1;rounded=1;arcSize=6;shadow=1;align=left;verticalAlign=middle;spacing=14;" vertex="1" parent="1">
  <mxGeometry x="40" y="30" width="{self.width - 80}" height="75" as="geometry" />
</mxCell>""")

    def add_actor(self, label, x, y=140, height=900, role="Actor"):
        cid = self._next_id("actor")
        # Actor icon
        icon_id = f"{cid}_icon"
        self.cells.append(f"""<mxCell id="{icon_id}" value="" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=#E3F2FD;strokeColor=#1976D2;strokeWidth=2;" vertex="1" parent="1">
  <mxGeometry x="{x - 20}" y="{y}" width="40" height="55" as="geometry" />
</mxCell>""")
        # Label below actor
        lbl_id = f"{cid}_lbl"
        val = f"&lt;b&gt;{html.escape(label)}&lt;/b&gt;&lt;br/&gt;&lt;span style=&quot;font-size:10px;color:#546E7A;&quot;&gt;&amp;laquo;{html.escape(role)}&amp;raquo;&lt;/span&gt;"
        self.cells.append(f"""<mxCell id="{lbl_id}" value="{val}" style="text;html=1;align=center;verticalAlign=top;fontSize=12;fontFamily=Segoe UI;" vertex="1" parent="1">
  <mxGeometry x="{x - 60}" y="{y + 60}" width="120" height="35" as="geometry" />
</mxCell>""")
        # Lifeline dashed line
        line_id = f"{cid}_line"
        line_start_y = y + 95
        line_end_y = y + height
        self.cells.append(f"""<mxCell id="{line_id}" value="" style="endArrow=none;dashed=1;html=1;rounded=0;strokeColor=#90A4AE;strokeWidth=1.5;strokeDasharray=6 4;" edge="1" parent="1">
  <mxGeometry relative="1" as="geometry">
    <mxPoint x="{x}" y="{line_start_y}" as="sourcePoint" />
    <mxPoint x="{x}" y="{line_end_y}" as="targetPoint" />
  </mxGeometry>
</mxCell>""")
        return x

    def add_lifeline(self, name, stereotype, x, y=140, width=130, height=900, theme="blue"):
        cid = self._next_id("ll")
        themes = {
            "blue": ("#E3F2FD", "#1565C0", "#0D47A1"),
            "green": ("#E8F5E9", "#2E7D32", "#1B5E20"),
            "orange": ("#FFF3E0", "#E65100", "#BF360C"),
            "purple": ("#F3E5F5", "#7B1FA2", "#4A148C"),
            "teal": ("#E0F2F1", "#00796B", "#004D40"),
            "pink": ("#FCE4EC", "#C2185B", "#880E4F"),
            "indigo": ("#E8EAF6", "#303F9F", "#1A237E"),
            "slate": ("#ECEFF1", "#455A64", "#263238")
        }
        bg, border, text_c = themes.get(theme, themes["blue"])
        val = f"&lt;div style=&quot;font-family:Segoe UI,sans-serif;text-align:center;&quot;&gt;&lt;span style=&quot;font-size:10px;color:#546E7A;letter-spacing:0.5px;&quot;&gt;&amp;laquo;{html.escape(stereotype)}&amp;raquo;&lt;/span&gt;&lt;br/&gt;&lt;b style=&quot;font-size:12px;color:{text_c};&quot;&gt;{html.escape(name)}&lt;/b&gt;&lt;/div&gt;"
        
        # Header Box
        box_id = f"{cid}_box"
        self.cells.append(f"""<mxCell id="{box_id}" value="{val}" style="shape=rectangle;whiteSpace=wrap;html=1;fillColor={bg};strokeColor={border};strokeWidth=1.5;rounded=1;arcSize=8;shadow=1;verticalAlign=middle;" vertex="1" parent="1">
  <mxGeometry x="{x - width // 2}" y="{y}" width="{width}" height="46" as="geometry" />
</mxCell>""")
        
        # Dashed lifeline
        line_id = f"{cid}_line"
        line_start_y = y + 46
        line_end_y = y + height
        self.cells.append(f"""<mxCell id="{line_id}" value="" style="endArrow=none;dashed=1;html=1;rounded=0;strokeColor=#90A4AE;strokeWidth=1.5;strokeDasharray=6 4;" edge="1" parent="1">
  <mxGeometry relative="1" as="geometry">
    <mxPoint x="{x}" y="{line_start_y}" as="sourcePoint" />
    <mxPoint x="{x}" y="{line_end_y}" as="targetPoint" />
  </mxGeometry>
</mxCell>""")
        return x

    def add_activation(self, x, y, height=60, width=14, theme="yellow"):
        cid = self._next_id("act")
        color_map = {
            "yellow": ("#FFF9C4", "#FBC02D"),
            "blue": ("#BBDEFB", "#1976D2"),
            "green": ("#C8E6C9", "#388E3C"),
            "orange": ("#FFE0B2", "#FB8C00"),
            "purple": ("#E1BEE7", "#8E24AA")
        }
        fill, stroke = color_map.get(theme, ("#FFF9C4", "#FBC02D"))
        self.cells.append(f"""<mxCell id="{cid}" value="" style="shape=rectangle;whiteSpace=wrap;html=1;fillColor={fill};strokeColor={stroke};strokeWidth=1.2;rounded=0;shadow=0;" vertex="1" parent="1">
  <mxGeometry x="{x - width // 2}" y="{y}" width="{width}" height="{height}" as="geometry" />
</mxCell>""")
        return cid

    def add_sync_call(self, from_x, to_x, y, label, msg_num=None, color="#1565C0"):
        cid = self._next_id("sync")
        num_str = f"&lt;b style=&quot;color:{color};&quot;&gt;{msg_num}. &lt;/b&gt;" if msg_num else ""
        val = f"&lt;div style=&quot;font-family:Segoe UI,sans-serif;font-size:11px;&quot;&gt;{num_str}{html.escape(label)}&lt;/div&gt;"
        self.cells.append(f"""<mxCell id="{cid}" value="{val}" style="endArrow=block;html=1;rounded=0;strokeColor={color};strokeWidth=1.5;endFill=1;align=center;verticalAlign=bottom;labelBackgroundColor=#FFFFFF;labelBorderColor=none;spacingBottom=2;fontFamily=Segoe UI;" edge="1" parent="1">
  <mxGeometry relative="1" as="geometry">
    <mxPoint x="{from_x}" y="{y}" as="sourcePoint" />
    <mxPoint x="{to_x}" y="{y}" as="targetPoint" />
  </mxGeometry>
</mxCell>""")

    def add_async_call(self, from_x, to_x, y, label, msg_num=None, color="#E65100"):
        cid = self._next_id("async")
        num_str = f"&lt;b style=&quot;color:{color};&quot;&gt;{msg_num}. &lt;/b&gt;" if msg_num else ""
        val = f"&lt;div style=&quot;font-family:Segoe UI,sans-serif;font-size:11px;&quot;&gt;{num_str}{html.escape(label)}&lt;/div&gt;"
        self.cells.append(f"""<mxCell id="{cid}" value="{val}" style="endArrow=open;html=1;rounded=0;strokeColor={color};strokeWidth=1.5;endFill=0;align=center;verticalAlign=bottom;labelBackgroundColor=#FFFFFF;spacingBottom=2;fontFamily=Segoe UI;" edge="1" parent="1">
  <mxGeometry relative="1" as="geometry">
    <mxPoint x="{from_x}" y="{y}" as="sourcePoint" />
    <mxPoint x="{to_x}" y="{y}" as="targetPoint" />
  </mxGeometry>
</mxCell>""")

    def add_return_msg(self, from_x, to_x, y, label, color="#546E7A"):
        cid = self._next_id("return")
        val = f"&lt;div style=&quot;font-family:Segoe UI,sans-serif;font-size:10px;color:{color};font-style:italic;&quot;&gt;{html.escape(label)}&lt;/div&gt;"
        self.cells.append(f"""<mxCell id="{cid}" value="{val}" style="endArrow=open;dashed=1;html=1;rounded=0;strokeColor={color};strokeWidth=1.2;strokeDasharray=4 3;endFill=0;align=center;verticalAlign=bottom;labelBackgroundColor=#FFFFFF;spacingBottom=2;fontFamily=Segoe UI;" edge="1" parent="1">
  <mxGeometry relative="1" as="geometry">
    <mxPoint x="{from_x}" y="{y}" as="sourcePoint" />
    <mxPoint x="{to_x}" y="{y}" as="targetPoint" />
  </mxGeometry>
</mxCell>""")

    def add_self_call(self, x, y, label, msg_num=None, width=45, height=28, color="#6A1B9A"):
        cid = self._next_id("self")
        num_str = f"&lt;b style=&quot;color:{color};&quot;&gt;{msg_num}. &lt;/b&gt;" if msg_num else ""
        val = f"&lt;div style=&quot;font-family:Segoe UI,sans-serif;font-size:11px;&quot;&gt;{num_str}{html.escape(label)}&lt;/div&gt;"
        self.cells.append(f"""<mxCell id="{cid}" value="{val}" style="endArrow=block;html=1;rounded=0;strokeColor={color};strokeWidth=1.5;endFill=1;align=left;verticalAlign=middle;labelBackgroundColor=#FFFFFF;spacingLeft=6;fontFamily=Segoe UI;edgeStyle=orthogonalEdgeStyle;curved=0;" edge="1" parent="1">
  <mxGeometry relative="1" as="geometry">
    <mxPoint x="{x + 7}" y="{y}" as="sourcePoint" />
    <mxPoint x="{x + 7}" y="{y + height}" as="targetPoint" />
    <Array as="points">
      <mxPoint x="{x + width}" y="{y}" />
      <mxPoint x="{x + width}" y="{y + height}" />
    </Array>
  </mxGeometry>
</mxCell>""")

    def add_alt_frame(self, x, y, width, height, title="alt", cond1="[Điều kiện 1]", cond2="[Điều kiện 2 / Else]", split_y=None):
        cid = self._next_id("alt")
        val = f"&lt;b style=&quot;font-size:11px;color:#37474F;&quot;&gt;{html.escape(title)}&lt;/b&gt; &lt;span style=&quot;font-size:10px;color:#0277BD;&quot;&gt;{html.escape(cond1)}&lt;/span&gt;"
        self.cells.append(f"""<mxCell id="{cid}" value="{val}" style="shape=umlFrame;whiteSpace=wrap;html=1;width=65;height=22;fillColor=none;strokeColor=#455A64;strokeWidth=1.5;align=left;verticalAlign=top;spacingLeft=6;spacingTop=2;fontFamily=Segoe UI;" vertex="1" parent="1">
  <mxGeometry x="{x}" y="{y}" width="{width}" height="{height}" as="geometry" />
</mxCell>""")
        if split_y and cond2:
            div_id = self._next_id("alt_div")
            lbl_id = self._next_id("alt_lbl2")
            self.cells.append(f"""<mxCell id="{div_id}" value="" style="endArrow=none;dashed=1;html=1;rounded=0;strokeColor=#455A64;strokeWidth=1.2;strokeDasharray=4 4;" edge="1" parent="1">
  <mxGeometry relative="1" as="geometry">
    <mxPoint x="{x}" y="{split_y}" as="sourcePoint" />
    <mxPoint x="{x + width}" y="{split_y}" as="targetPoint" />
  </mxGeometry>
</mxCell>""")
            val2 = f"&lt;span style=&quot;font-size:10px;color:#C62828;font-weight:bold;&quot;&gt;{html.escape(cond2)}&lt;/span&gt;"
            self.cells.append(f"""<mxCell id="{lbl_id}" value="{val2}" style="text;html=1;align=left;verticalAlign=top;fontSize=10;fontFamily=Segoe UI;" vertex="1" parent="1">
  <mxGeometry x="{x + 8}" y="{split_y + 4}" width="200" height="20" as="geometry" />
</mxCell>""")

    def add_opt_frame(self, x, y, width, height, condition="[Điều kiện]"):
        cid = self._next_id("opt")
        val = f"&lt;b style=&quot;font-size:11px;color:#37474F;&quot;&gt;opt&lt;/b&gt; &lt;span style=&quot;font-size:10px;color:#2E7D32;&quot;&gt;{html.escape(condition)}&lt;/span&gt;"
        self.cells.append(f"""<mxCell id="{cid}" value="{val}" style="shape=umlFrame;whiteSpace=wrap;html=1;width=55;height=22;fillColor=none;strokeColor=#2E7D32;strokeWidth=1.5;align=left;verticalAlign=top;spacingLeft=6;spacingTop=2;fontFamily=Segoe UI;" vertex="1" parent="1">
  <mxGeometry x="{x}" y="{y}" width="{width}" height="{height}" as="geometry" />
</mxCell>""")

    def add_loop_frame(self, x, y, width, height, condition="[Lặp với mỗi phần tử]"):
        cid = self._next_id("loop")
        val = f"&lt;b style=&quot;font-size:11px;color:#37474F;&quot;&gt;loop&lt;/b&gt; &lt;span style=&quot;font-size:10px;color:#6A1B9A;&quot;&gt;{html.escape(condition)}&lt;/span&gt;"
        self.cells.append(f"""<mxCell id="{cid}" value="{val}" style="shape=umlFrame;whiteSpace=wrap;html=1;width=60;height=22;fillColor=none;strokeColor=#6A1B9A;strokeWidth=1.5;align=left;verticalAlign=top;spacingLeft=6;spacingTop=2;fontFamily=Segoe UI;" vertex="1" parent="1">
  <mxGeometry x="{x}" y="{y}" width="{width}" height="{height}" as="geometry" />
</mxCell>""")

    def add_note_box(self, x, y, width, height, text):
        cid = self._next_id("note")
        val = f"&lt;div style=&quot;font-family:Segoe UI,sans-serif;font-size:10px;color:#37474F;line-height:1.35;&quot;&gt;{html.escape(text)}&lt;/div&gt;"
        self.cells.append(f"""<mxCell id="{cid}" value="{val}" style="shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#FFFDE7;strokeColor=#FBC02D;strokeWidth=1.2;size=12;align=left;verticalAlign=top;spacing=6;shadow=1;" vertex="1" parent="1">
  <mxGeometry x="{x}" y="{y}" width="{width}" height="{height}" as="geometry" />
</mxCell>""")

    def add_custom_box(self, x, y, width, height, html_content, bg="#FFFFFF", border="#CFD8DC"):
        cid = self._next_id("cbox")
        self.cells.append(f"""<mxCell id="{cid}" value="{html.escape(html_content)}" style="shape=rectangle;whiteSpace=wrap;html=1;fillColor={bg};strokeColor={border};strokeWidth=1.2;rounded=1;arcSize=6;shadow=1;align=left;verticalAlign=top;spacing=10;" vertex="1" parent="1">
  <mxGeometry x="{x}" y="{y}" width="{width}" height="{height}" as="geometry" />
</mxCell>""")

    def render(self):
        cells_xml = "\n        ".join(self.cells)
        return f"""  <diagram id="{self.diag_id}" name="{html.escape(self.name)}">
    <mxGraphModel dx="1600" dy="1200" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="{self.width}" pageHeight="{self.height}" math="0" shadow="0">
      <root>
        <mxCell id="0" />
        <mxCell id="1" parent="0" />
        {cells_xml}
      </root>
    </mxGraphModel>
  </diagram>"""

print("SequenceDiagramBuilder helper defined successfully.")
