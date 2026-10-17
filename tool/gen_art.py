"""Génère les illustrations SVG de Nomade : portraits des personnages, fins,
icônes de jauges et de badges, illustration d'accueil, icône d'app.
Style : formes plates géométriques, palette « bitume au coucher du soleil »."""
import os
import sys

OUT = sys.argv[1]
W, H = 290, 354

ASPHALT = '#1C1916'
ASPH2 = '#2A2521'
SUNSET = '#F2A65A'
EMBER = '#E76F51'
CREAM = '#F4EDE4'
DUST = '#A89F94'
SAGE = '#8AB17D'


def shade(hexc, f):
    h = hexc.lstrip('#')
    r, g, b = int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16)
    if f < 0:
        r, g, b = [int(c * (1 + f)) for c in (r, g, b)]
    else:
        r, g, b = [int(c + (255 - c) * f) for c in (r, g, b)]
    return '#%02X%02X%02X' % (r, g, b)


def svg(body, w=W, h=H):
    return (f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {w} {h}" width="{w}" height="{h}">'
            + body + '</svg>')


def scene(bg, inner, ground=True):
    g = f'<rect x="0" y="0" width="{W}" height="{H}" fill="{bg}"/>'
    if ground:
        g += f'<rect x="0" y="250" width="{W}" height="104" fill="{shade(bg, -0.2)}"/>'
    return svg(g + inner)


# ---------------------------------------------------------------- humains
SKINS = {'a': '#F1C7A5', 'b': '#D9A07E', 'c': '#B07650', 'd': '#7A4B30', 'e': '#E8B48F'}


def hair_back(style, col):
    if style == 'long':
        return f'<path d="M86 196 Q84 122 145 120 Q206 122 204 196 L212 286 L78 286 Z" fill="{col}"/>'
    if style == 'midlong':
        return f'<path d="M88 196 Q86 124 145 122 Q204 124 202 196 L204 238 L86 238 Z" fill="{col}"/>'
    return ''


def hair_front(style, col):
    if style in ('short', 'long', 'midlong', 'bun'):
        s = f'<path d="M90 186 Q90 126 145 126 Q200 126 200 186 Q194 156 168 150 Q150 164 120 156 Q98 160 90 186 Z" fill="{col}"/>'
        if style == 'bun':
            s = f'<circle cx="145" cy="118" r="24" fill="{col}"/>' + s
        return s
    if style == 'curly':
        out = ''
        for cx, cy, r in [(100, 168, 18), (112, 144, 20), (136, 132, 22), (162, 132, 22), (186, 146, 20), (196, 170, 17), (124, 150, 16), (170, 150, 16)]:
            out += f'<circle cx="{cx}" cy="{cy}" r="{r}" fill="{col}"/>'
        return out
    if style == 'bald':
        return (f'<path d="M92 196 Q90 176 98 168 L100 200 Z" fill="{col}"/>'
                f'<path d="M198 196 Q200 176 192 168 L190 200 Z" fill="{col}"/>')
    if style == 'buzz':
        return f'<path d="M92 184 Q92 132 145 132 Q198 132 198 184 Q190 152 145 150 Q100 152 92 184 Z" fill="{col}"/>'
    return ''


def hat(kind, col):
    if kind == 'cap':
        return (f'<path d="M89 182 Q92 128 145 126 Q198 128 201 182 Z" fill="{col}"/>'
                f'<path d="M150 170 Q206 168 224 182 L196 186 Z" fill="{shade(col, -0.25)}"/>')
    if kind == 'capback':
        return (f'<path d="M89 182 Q92 128 145 126 Q198 128 201 182 Z" fill="{col}"/>'
                f'<path d="M140 170 Q84 168 66 182 L94 186 Z" fill="{shade(col, -0.25)}"/>')
    if kind == 'kepi':
        return (f'<path d="M98 168 L104 122 Q145 112 186 122 L192 168 Z" fill="{col}"/>'
                f'<rect x="96" y="160" width="98" height="10" fill="{shade(col, -0.35)}"/>'
                f'<path d="M100 170 Q145 194 196 170 L194 176 Q145 196 98 176 Z" fill="{ASPHALT}"/>'
                f'<circle cx="145" cy="140" r="7" fill="{SUNSET}"/>')
    if kind == 'tricorne':
        return (f'<path d="M84 168 Q100 112 145 112 Q190 112 206 168 Q145 150 84 168 Z" fill="{col}"/>'
                f'<rect x="92" y="162" width="106" height="8" rx="3" fill="{shade(col, -0.3)}"/>')
    if kind == 'beret':
        return (f'<ellipse cx="138" cy="140" rx="62" ry="24" fill="{col}"/>'
                f'<circle cx="138" cy="116" r="5" fill="{col}"/>')
    if kind == 'bandana':
        return (f'<path d="M90 172 Q92 128 145 128 Q198 128 200 172 Q145 160 90 172 Z" fill="{col}"/>'
                f'<path d="M198 166 L222 182 L214 156 Z" fill="{col}"/>'
                f'<circle cx="120" cy="146" r="4" fill="{CREAM}"/><circle cx="160" cy="142" r="4" fill="{CREAM}"/><circle cx="140" cy="158" r="3" fill="{CREAM}"/>')
    if kind == 'bucket':
        return (f'<path d="M100 166 L108 122 Q145 112 182 122 L190 166 Z" fill="{col}"/>'
                f'<ellipse cx="145" cy="168" rx="70" ry="12" fill="{shade(col, -0.2)}"/>')
    if kind == 'beanie':
        return (f'<path d="M90 176 Q90 120 145 120 Q200 120 200 176 Z" fill="{col}"/>'
                f'<rect x="88" y="164" width="114" height="18" rx="6" fill="{shade(col, -0.2)}"/>'
                f'<circle cx="145" cy="112" r="12" fill="{shade(col, 0.3)}"/>')
    if kind == 'straw':
        return (f'<ellipse cx="145" cy="164" rx="86" ry="16" fill="{col}"/>'
                f'<path d="M106 164 Q110 116 145 116 Q180 116 184 164 Z" fill="{col}"/>'
                f'<rect x="108" y="148" width="74" height="10" fill="{EMBER}"/>')
    if kind == 'turban':
        return (f'<path d="M88 176 Q86 118 145 116 Q204 118 202 176 Q145 150 88 176 Z" fill="{col}"/>'
                f'<path d="M96 160 Q145 128 196 150" stroke="{shade(col, -0.2)}" stroke-width="8" fill="none"/>')
    if kind == 'headphones':
        return (f'<path d="M86 196 Q86 112 145 112 Q204 112 204 196" stroke="{col}" stroke-width="10" fill="none"/>'
                f'<rect x="76" y="180" width="22" height="40" rx="9" fill="{col}"/>'
                f'<rect x="192" y="180" width="22" height="40" rx="9" fill="{col}"/>')
    return ''


def face(extras, skin):
    s = ''
    if 'sunglasses' in extras:
        s += (f'<rect x="108" y="186" width="32" height="20" rx="6" fill="{ASPHALT}"/>'
              f'<rect x="150" y="186" width="32" height="20" rx="6" fill="{ASPHALT}"/>'
              f'<rect x="138" y="192" width="14" height="4" fill="{ASPHALT}"/>')
    else:
        if 'closed' in extras:
            s += (f'<path d="M118 198 Q126 204 134 198" stroke="{ASPHALT}" stroke-width="4" fill="none" stroke-linecap="round"/>'
                  f'<path d="M156 198 Q164 204 172 198" stroke="{ASPHALT}" stroke-width="4" fill="none" stroke-linecap="round"/>')
        else:
            s += f'<circle cx="126" cy="198" r="5" fill="{ASPHALT}"/><circle cx="164" cy="198" r="5" fill="{ASPHALT}"/>'
        if 'glasses' in extras:
            s += (f'<circle cx="126" cy="198" r="15" stroke="{ASPHALT}" stroke-width="3.5" fill="none"/>'
                  f'<circle cx="164" cy="198" r="15" stroke="{ASPHALT}" stroke-width="3.5" fill="none"/>'
                  f'<path d="M141 198 H149" stroke="{ASPHALT}" stroke-width="3.5"/>')
        if 'monocle' in extras:
            s += (f'<circle cx="164" cy="198" r="15" stroke="{SUNSET}" stroke-width="3.5" fill="none"/>'
                  f'<path d="M178 204 Q184 240 172 262" stroke="{SUNSET}" stroke-width="2" fill="none"/>')
    if 'frown' in extras:
        s += f'<path d="M132 230 Q145 222 158 230" stroke="{ASPHALT}" stroke-width="4" fill="none" stroke-linecap="round"/>'
    elif 'mustache' not in extras and 'beard' not in extras:
        s += f'<path d="M130 224 Q145 236 160 224" stroke="{ASPHALT}" stroke-width="4" fill="none" stroke-linecap="round"/>'
    if 'cheeks' in extras:
        s += f'<circle cx="114" cy="216" r="7" fill="{EMBER}" opacity="0.35"/><circle cx="176" cy="216" r="7" fill="{EMBER}" opacity="0.35"/>'
    return s


def facial_hair(extras, col):
    s = ''
    if 'beard' in extras:
        s += f'<path d="M92 200 Q96 262 145 266 Q194 262 198 200 Q186 236 145 238 Q104 236 92 200 Z" fill="{col}"/>'
        s += f'<path d="M132 226 Q145 232 158 226" stroke="{ASPHALT}" stroke-width="4" fill="none" stroke-linecap="round"/>'
    if 'mustache' in extras:
        s += f'<path d="M120 222 Q145 208 170 222 Q158 232 145 226 Q132 232 120 222 Z" fill="{col}"/>'
    return s


def prop(kind):
    if kind == 'wrench':
        return ('<g transform="translate(212 268) rotate(-30)">'
                '<rect x="-7" y="-4" width="14" height="70" rx="6" fill="#B8C4CA"/>'
                '<path d="M-18 -10 A18 18 0 1 1 18 -10 L8 -10 L8 -22 L-8 -22 L-8 -10 Z" fill="#B8C4CA"/></g>')
    if kind == 'phone':
        return (f'<g transform="translate(206 262) rotate(12)"><rect x="-20" y="-34" width="40" height="70" rx="8" fill="{ASPHALT}"/>'
                f'<rect x="-15" y="-27" width="30" height="52" rx="3" fill="{SUNSET}"/></g>')
    if kind == 'camera':
        return (f'<g transform="translate(200 280)"><rect x="-34" y="-22" width="68" height="46" rx="8" fill="{ASPHALT}"/>'
                f'<rect x="-14" y="-30" width="22" height="10" rx="3" fill="{ASPHALT}"/>'
                f'<circle cx="0" cy="2" r="15" fill="{DUST}"/><circle cx="0" cy="2" r="8" fill="{ASPHALT}"/></g>')
    if kind == 'laptop':
        return (f'<g transform="translate(145 312)"><rect x="-70" y="-46" width="140" height="80" rx="6" fill="{DUST}"/>'
                f'<rect x="-84" y="30" width="168" height="10" rx="4" fill="{shade(DUST, -0.3)}"/>'
                f'<circle cx="0" cy="-6" r="9" fill="{CREAM}"/></g>')
    if kind == 'clipboard':
        return (f'<g transform="translate(208 286) rotate(10)"><rect x="-26" y="-36" width="52" height="70" rx="5" fill="#8B6A4A"/>'
                f'<rect x="-20" y="-28" width="40" height="56" fill="{CREAM}"/><rect x="-10" y="-42" width="20" height="10" rx="3" fill="{DUST}"/>'
                f'<path d="M-13 -14 H13 M-13 -2 H13 M-13 10 H6" stroke="{DUST}" stroke-width="3"/></g>')
    if kind == 'guitar':
        return (f'<g transform="translate(200 300) rotate(-35)"><rect x="-5" y="-110" width="10" height="90" fill="#6B4A2F"/>'
                f'<circle cx="0" cy="0" r="30" fill="{EMBER}"/><circle cx="0" cy="-26" r="22" fill="{EMBER}"/>'
                f'<circle cx="0" cy="-6" r="8" fill="{ASPHALT}"/></g>')
    if kind == 'surfboard':
        return (f'<g transform="translate(232 230) rotate(12)"><ellipse cx="0" cy="0" rx="24" ry="120" fill="{CREAM}"/>'
                f'<rect x="-3" y="-120" width="6" height="240" fill="{EMBER}"/></g>')
    if kind == 'grapes':
        out = '<g transform="translate(212 278)">'
        for cx, cy in [(-12, -10), (0, -10), (12, -10), (-6, 2), (6, 2), (0, 14), (-18, -22), (18, -22), (0, -22)]:
            out += f'<circle cx="{cx}" cy="{cy}" r="8" fill="#6A3D7A"/>'
        return out + f'<path d="M0 -30 Q4 -44 14 -46" stroke="{SAGE}" stroke-width="4" fill="none"/></g>'
    if kind == 'stethoscope':
        return (f'<path d="M110 262 Q112 300 145 304 Q178 300 180 262" stroke="{DUST}" stroke-width="6" fill="none"/>'
                f'<circle cx="145" cy="314" r="10" fill="{DUST}"/>')
    if kind == 'apples':
        return (f'<g transform="translate(208 296)"><path d="M-40 -12 H40 L30 30 H-30 Z" fill="#8B6A4A"/>'
                f'<circle cx="-18" cy="-16" r="13" fill="{EMBER}"/><circle cx="6" cy="-20" r="13" fill="#C4553C"/><circle cx="26" cy="-14" r="11" fill="{SUNSET}"/></g>')
    if kind == 'rod':
        return (f'<path d="M206 330 L262 120" stroke="#6B4A2F" stroke-width="6" stroke-linecap="round"/>'
                f'<path d="M262 120 Q276 200 270 250" stroke="{CREAM}" stroke-width="1.5" fill="none"/>')
    if kind == 'thumb':
        return (f'<g transform="translate(214 262)"><rect x="-18" y="0" width="36" height="34" rx="10" fill="{SKINS["b"]}"/>'
                f'<rect x="-8" y="-34" width="16" height="40" rx="8" fill="{SKINS["b"]}"/></g>')
    if kind == 'bag':
        return f'<rect x="196" y="262" width="56" height="70" rx="14" fill="{SAGE}"/><rect x="206" y="278" width="36" height="16" rx="5" fill="{shade(SAGE, -0.25)}"/>'
    if kind == 'tie':
        return f'<path d="M145 268 L136 282 L145 330 L154 282 Z" fill="{EMBER}"/>'
    if kind == 'badge':
        return f'<path d="M110 290 L118 282 L126 290 L118 302 Z" fill="{SUNSET}"/>'
    if kind == 'scarf':
        return f'<path d="M108 262 Q145 280 182 262 L186 276 Q145 296 104 276 Z" fill="{EMBER}"/><rect x="160" y="276" width="16" height="40" rx="4" fill="{EMBER}"/>'
    if kind == 'pearls':
        return ''.join(f'<circle cx="{145 + dx}" cy="{270 + abs(dx) * -0.12 + 6}" r="5" fill="{CREAM}"/>' for dx in range(-30, 31, 12))
    return ''


def human(bg, skin='b', hair='short', hair_col='#3B2A22', top='#2E3E46', hat_kind=None, hat_col=None,
          extras=(), props=(), collar=None):
    sk = SKINS[skin]
    body = hair_back(hair, hair_col)
    body += f'<path d="M64 354 Q64 268 145 260 Q226 268 226 354 Z" fill="{top}"/>'
    if collar:
        body += f'<path d="M118 262 L145 292 L172 262 Z" fill="{collar}"/>'
    body += f'<rect x="128" y="232" width="34" height="34" fill="{shade(sk, -0.12)}"/>'
    body += f'<circle cx="145" cy="190" r="56" fill="{sk}"/>'
    body += facial_hair(extras, hair_col if hair != 'bald' else '#9A9088')
    body += face(extras, sk)
    if not hat_kind or hat_kind in ('headphones',):
        body += hair_front(hair, hair_col)
    elif hat_kind in ('bandana', 'beret', 'straw', 'bucket'):
        body += hair_front('bald' if hair == 'bald' else 'buzz', hair_col) if hair != 'long' else ''
    if hat_kind:
        body += hat(hat_kind, hat_col or EMBER)
    for p in props:
        body += prop(p)
    return scene(bg, body)


# ---------------------------------------------------------------- objets
def van_shape(x, y, s=1.0, body=CREAM, win=ASPHALT, extra=''):
    return (f'<g transform="translate({x} {y}) scale({s})">'
            f'<path d="M6 34 V14 Q6 6 14 6 H70 L92 22 Q100 24 100 32 V34 Z" fill="{body}"/>'
            f'<path d="M72 9 L88 22 H72 Z" fill="{win}"/>'
            f'<rect x="18" y="12" width="20" height="10" rx="2" fill="{win}"/>'
            f'<rect x="44" y="12" width="20" height="10" rx="2" fill="{win}"/>'
            f'<rect x="0" y="32" width="104" height="5" rx="2" fill="{DUST}"/>'
            f'<circle cx="26" cy="38" r="8" fill="{win}" stroke="{body}" stroke-width="3"/>'
            f'<circle cx="80" cy="38" r="8" fill="{win}" stroke="{body}" stroke-width="3"/>{extra}</g>')


ART = {}

ART['toi'] = scene('#5A4636',
    f'<circle cx="145" cy="200" r="80" fill="{SUNSET}"/>'
    f'<rect x="0" y="200" width="290" height="154" fill="#3F3126"/>'
    f'<path d="M145 354 L120 200 M145 354 L170 200" stroke="#5A4636" stroke-width="3"/>'
    f'<path d="M106 354 Q106 272 145 266 Q184 272 184 354 Z" fill="{ASPHALT}"/>'
    f'<circle cx="145" cy="240" r="30" fill="{ASPHALT}"/>'
    f'<path d="M118 232 Q120 204 145 204 Q170 204 172 232 Z" fill="#3B2A22"/>'
    f'<rect x="168" y="270" width="26" height="54" rx="10" fill="{EMBER}"/>', ground=False)

ART['momo'] = human('#4E6672', skin='b', hair='short', hat_kind='cap', hat_col=EMBER,
                    extras=('mustache',), props=('wrench',), top='#2E3E46')

ART['depanneur'] = scene('#7A4A32',
    f'<rect x="150" y="60" width="16" height="170" fill="{DUST}"/>'
    f'<path d="M158 70 L60 120" stroke="{DUST}" stroke-width="12" stroke-linecap="round"/>'
    f'<path d="M60 120 L60 170" stroke="{CREAM}" stroke-width="3"/>'
    f'<path d="M60 170 Q60 196 80 196 Q96 196 96 182" stroke="{CREAM}" stroke-width="8" fill="none" stroke-linecap="round"/>'
    f'<rect x="40" y="226" width="210" height="34" rx="6" fill="{SUNSET}"/>'
    f'<rect x="196" y="186" width="60" height="50" rx="8" fill="{SUNSET}"/>'
    f'<rect x="208" y="196" width="34" height="20" rx="3" fill="{ASPHALT}"/>'
    f'<circle cx="84" cy="266" r="20" fill="{ASPHALT}" stroke="{CREAM}" stroke-width="5"/>'
    f'<circle cx="214" cy="266" r="20" fill="{ASPHALT}" stroke="{CREAM}" stroke-width="5"/>'
    f'<rect x="206" y="176" width="20" height="10" rx="3" fill="{EMBER}"/>')

ART['gerard'] = human('#6B5640', skin='e', hair='bald', hair_col='#D9D2C8', top='#C9B48F',
                      extras=('glasses', 'mustache', 'cheeks'), collar=CREAM)

ART['maman'] = human('#8A4F55', skin='e', hair='bun', hair_col='#B9AFA6', top='#5E3A4A',
                     extras=('glasses', 'cheeks'), props=('phone', 'pearls'))

ART['soeur'] = human('#6E4C70', skin='e', hair='long', hair_col='#5A3A2A', top='#C98A4B',
                     extras=('cheeks',), props=('phone',))

ART['gendarme'] = human('#2F3E66', skin='a', hair='buzz', hair_col='#3B2A22', top='#1E2A4A',
                        hat_kind='kepi', hat_col='#1E2A4A', extras=('frown',), props=('badge',), collar=CREAM)

ART['police'] = human('#3F4F80', skin='c', hair='buzz', hair_col='#2A1E18', top='#253463',
                      hat_kind='cap', hat_col='#253463', extras=('sunglasses', 'frown'), props=('badge',))

ART['chienErrant'] = scene('#7A6450',
    f'<path d="M88 250 Q86 200 120 196 L190 196 Q214 198 214 236 L214 250 Z" fill="#C9A27A"/>'
    f'<rect x="96" y="236" width="16" height="50" rx="6" fill="#C9A27A"/>'
    f'<rect x="190" y="236" width="16" height="50" rx="6" fill="#C9A27A"/>'
    f'<path d="M214 210 Q246 196 252 166" stroke="#C9A27A" stroke-width="12" fill="none" stroke-linecap="round"/>'
    f'<circle cx="100" cy="164" r="44" fill="#C9A27A"/>'
    f'<path d="M64 140 Q48 176 64 200 Q78 180 80 150 Z" fill="#8B6A4A"/>'
    f'<path d="M136 140 Q152 176 136 200 Q122 180 120 150 Z" fill="#8B6A4A"/>'
    f'<ellipse cx="100" cy="186" rx="22" ry="16" fill="{CREAM}"/>'
    f'<circle cx="100" cy="178" r="7" fill="{ASPHALT}"/>'
    f'<circle cx="84" cy="156" r="5" fill="{ASPHALT}"/><circle cx="116" cy="156" r="5" fill="{ASPHALT}"/>'
    f'<path d="M100 186 V196" stroke="{ASPHALT}" stroke-width="3"/>')

ART['veto'] = human('#3F6B66', skin='a', hair='midlong', hair_col='#C98A4B', top=CREAM,
                    extras=('glasses',), props=('stethoscope',))

ART['voisin'] = human('#5B6B3E', skin='e', hair='bald', hair_col='#8E8478', top='#E07A5F',
                      extras=('frown', 'beard'))

ART['lila'] = human('#9A4D6B', skin='a', hair='long', hair_col='#E8C98A', top='#F2D7C9',
                    extras=('sunglasses',), props=('camera',))

ART['marque'] = scene('#8A5A44',
    f'<rect x="112" y="80" width="66" height="190" rx="22" fill="{CREAM}"/>'
    f'<rect x="124" y="58" width="42" height="28" rx="8" fill="{ASPHALT}"/>'
    f'<rect x="112" y="150" width="66" height="54" fill="{SUNSET}"/>'
    f'<path d="M128 176 L140 188 L164 164" stroke="{ASPHALT}" stroke-width="7" fill="none" stroke-linecap="round" stroke-linejoin="round"/>'
    f'<path d="M48 110 L60 98 M230 110 L242 98 M40 170 H56 M234 170 H250" stroke="{SUNSET}" stroke-width="5" stroke-linecap="round"/>')

ART['story'] = scene('#5B4A80',
    f'<rect x="90" y="40" width="110" height="220" rx="20" fill="{ASPHALT}"/>'
    f'<rect x="98" y="52" width="94" height="196" rx="12" fill="{SUNSET}"/>'
    f'<circle cx="145" cy="190" r="34" fill="{EMBER}"/>'
    f'<path d="M98 248 L132 196 L156 228 L172 206 L192 236 V248 Z" fill="#7A4B30"/>'
    f'<path d="M145 92 C130 72 104 92 145 124 C186 92 160 72 145 92 Z" fill="{EMBER}"/>'
    f'<path d="M106 62 H184" stroke="{CREAM}" stroke-width="4" stroke-linecap="round"/>'
    f'<circle cx="230" cy="80" r="16" fill="{EMBER}"/><path d="M222 80 H238 M230 72 V88" stroke="{CREAM}" stroke-width="3"/>')

ART['commentaires'] = scene('#6A5A8A',
    f'<rect x="30" y="50" width="160" height="70" rx="18" fill="{CREAM}"/><path d="M60 118 L50 144 L84 118 Z" fill="{CREAM}"/>'
    f'<path d="M54 76 H160 M54 96 H130" stroke="{DUST}" stroke-width="7" stroke-linecap="round"/>'
    f'<rect x="100" y="150" width="160" height="70" rx="18" fill="{EMBER}"/><path d="M230 218 L240 244 L206 218 Z" fill="{EMBER}"/>'
    f'<path d="M124 176 H232 M124 196 H200" stroke="{CREAM}" stroke-width="7" stroke-linecap="round"/>'
    f'<rect x="40" y="250" width="110" height="50" rx="16" fill="{CREAM}"/><path d="M60 275 H130" stroke="{DUST}" stroke-width="7" stroke-linecap="round"/>', ground=False)

ART['manager'] = human('#3A4148', skin='a', hair='short', hair_col='#1C1916', top='#22262B',
                       extras=('sunglasses',), props=('tie',), collar=CREAM)

ART['client'] = human('#3F6A63', skin='c', hair='short', hair_col='#1C1916', top='#5B7FA6',
                      extras=('glasses',), props=('laptop',))

ART['vendeur'] = scene('#4D4170',
    f'<ellipse cx="150" cy="150" rx="86" ry="74" transform="rotate(-25 150 150)" fill="{CREAM}"/>'
    f'<ellipse cx="150" cy="150" rx="66" ry="54" transform="rotate(-25 150 150)" fill="{DUST}"/>'
    f'<path d="M150 150 L210 96" stroke="{ASPHALT}" stroke-width="6"/>'
    f'<circle cx="212" cy="94" r="10" fill="{SUNSET}"/>'
    f'<rect x="138" y="196" width="24" height="70" fill="{DUST}"/>'
    f'<rect x="104" y="260" width="92" height="16" rx="5" fill="{ASPHALT}"/>'
    f'<path d="M232 58 Q252 72 250 96 M244 40 Q276 64 270 106" stroke="{SUNSET}" stroke-width="5" fill="none" stroke-linecap="round"/>')

ART['lea'] = human('#9A6A3A', skin='b', hair='long', hair_col='#2A1E18', top=SAGE,
                   hat_kind='bandana', hat_col=EMBER, extras=('cheeks',))

ART['festival'] = scene('#5E3F6E',
    f'<path d="M30 250 L145 90 L260 250 Z" fill="{EMBER}"/>'
    f'<path d="M88 250 L145 90 L202 250 Z" fill="{SUNSET}"/>'
    f'<path d="M145 90 V60" stroke="{CREAM}" stroke-width="4"/><path d="M145 60 L172 70 L145 80 Z" fill="{CREAM}"/>'
    f'<path d="M124 250 Q145 196 166 250 Z" fill="{ASPHALT}"/>'
    f'<circle cx="40" cy="60" r="4" fill="{CREAM}"/><circle cx="240" cy="44" r="3" fill="{CREAM}"/><circle cx="70" cy="30" r="2.5" fill="{CREAM}"/><circle cx="210" cy="96" r="3" fill="{CREAM}"/>')

ART['message'] = scene('#8A4A5E',
    f'<rect x="54" y="100" width="182" height="126" rx="10" fill="{CREAM}"/>'
    f'<path d="M54 110 L145 176 L236 110" stroke="{DUST}" stroke-width="6" fill="none" stroke-linejoin="round"/>'
    f'<path d="M145 196 C128 172 96 192 145 232 C194 192 162 172 145 196 Z" fill="{EMBER}"/>'
    f'<circle cx="230" cy="96" r="18" fill="{SUNSET}"/><text x="230" y="103" text-anchor="middle" font-family="sans-serif" font-weight="bold" font-size="20" fill="{ASPHALT}">1</text>')

ART['sam'] = human('#8A4545', skin='c', hair='curly', hair_col='#2A1E18', top=SUNSET,
                   extras=('cheeks',), props=('scarf',))

ART['tiago'] = human('#2F6B80', skin='c', hair='midlong', hair_col='#E8C98A', top='#2A9D8F',
                     props=('surfboard',))

ART['guardia'] = human('#3E5E3A', skin='b', hair='buzz', hair_col='#1C1916', top='#2F4A2C',
                       hat_kind='tricorne', hat_col=ASPHALT, extras=('mustache', 'frown'), props=('badge',))

ART['douanier'] = human('#3A5A48', skin='d', hair='buzz', hair_col='#1C1916', top='#2A4436',
                        hat_kind='kepi', hat_col='#2A4436', extras=('mustache',), props=('clipboard',))

ART['rachid'] = human('#8A5A3A', skin='c', hair='short', hair_col='#1C1916', top='#3D5A80',
                      hat_kind='capback', hat_col=SAGE, extras=('beard',), props=('wrench',))

ART['guide'] = scene('#B07A3A',
    f'<circle cx="220" cy="80" r="34" fill="{CREAM}"/>'
    f'<path d="M0 250 Q80 214 160 240 T290 236 V354 H0 Z" fill="#C9934E"/>'
    f'<path d="M60 230 Q62 176 100 172 Q118 140 136 172 Q150 140 168 172 Q196 174 200 200 L204 230 Z" fill="#7A4B30"/>'
    f'<rect x="72" y="224" width="12" height="70" rx="4" fill="#7A4B30"/><rect x="100" y="224" width="12" height="70" rx="4" fill="#7A4B30"/>'
    f'<rect x="160" y="224" width="12" height="70" rx="4" fill="#7A4B30"/><rect x="184" y="224" width="12" height="70" rx="4" fill="#7A4B30"/>'
    f'<path d="M196 196 Q220 160 224 120 Q240 108 252 120 Q256 132 240 136 Q234 172 212 210 Z" fill="#7A4B30"/>'
    f'<circle cx="244" cy="122" r="3" fill="{ASPHALT}"/>'
    f'<path d="M120 172 L120 150 Q132 138 144 150 L144 172 Z" fill="{EMBER}"/>', ground=False)

ART['yves'] = human('#5E7A3E', skin='e', hair='short', hair_col='#8E8478', top='#3D5A80',
                    hat_kind='beret', hat_col='#2A2521', extras=('cheeks', 'mustache'), props=('apples',))

ART['meteo'] = scene('#465560',
    f'<circle cx="110" cy="136" r="44" fill="{CREAM}"/><circle cx="168" cy="120" r="54" fill="{CREAM}"/>'
    f'<circle cx="214" cy="150" r="36" fill="{CREAM}"/><rect x="70" y="140" width="180" height="46" rx="23" fill="{CREAM}"/>'
    f'<path d="M160 190 L136 240 H158 L140 296 L196 222 H170 L188 190 Z" fill="{SUNSET}"/>'
    f'<path d="M90 206 L80 230 M112 214 L102 238 M220 206 L210 230" stroke="#9FB4C2" stroke-width="5" stroke-linecap="round"/>', ground=False)

ART['appli'] = scene('#355E80',
    f'<rect x="80" y="40" width="130" height="250" rx="22" fill="{ASPHALT}"/>'
    f'<rect x="90" y="54" width="110" height="222" rx="12" fill="#CFE3D4"/>'
    f'<path d="M90 120 Q130 140 200 110 M90 200 Q150 180 200 220 M140 54 Q130 160 160 276" stroke="{CREAM}" stroke-width="8" fill="none"/>'
    f'<path d="M145 120 C120 120 112 142 112 152 C112 176 145 206 145 206 C145 206 178 176 178 152 C178 142 170 120 145 120 Z" fill="{EMBER}"/>'
    f'<circle cx="145" cy="152" r="12" fill="{CREAM}"/>'
    f'<path d="M108 250 L114 238 L120 250 M124 250 L130 238 L136 250 M140 250 L146 238 L152 250" stroke="{SUNSET}" stroke-width="3" fill="none"/>', ground=False)

ART['ados'] = scene('#6A6030',
    f'<rect x="80" y="80" width="130" height="180" rx="16" fill="{ASPHALT}"/>'
    f'<circle cx="145" cy="200" r="42" fill="{ASPH2}"/><circle cx="145" cy="200" r="20" fill="{DUST}"/>'
    f'<circle cx="145" cy="122" r="22" fill="{ASPH2}"/><circle cx="145" cy="122" r="9" fill="{DUST}"/>'
    f'<path d="M226 120 Q246 150 226 180 M240 100 Q272 150 240 200 M64 120 Q44 150 64 180 M50 100 Q18 150 50 200" stroke="{SUNSET}" stroke-width="6" fill="none" stroke-linecap="round"/>'
    f'<path d="M40 60 V30 L60 26 V56" stroke="{CREAM}" stroke-width="4" fill="none"/><circle cx="36" cy="60" r="6" fill="{CREAM}"/><circle cx="56" cy="56" r="6" fill="{CREAM}"/>')

ART['banque'] = scene('#46525A',
    f'<path d="M60 120 L145 64 L230 120 Z" fill="{CREAM}"/>'
    f'<rect x="70" y="122" width="150" height="10" fill="{CREAM}"/>'
    f'<rect x="84" y="138" width="18" height="90" fill="{CREAM}"/><rect x="122" y="138" width="18" height="90" fill="{CREAM}"/>'
    f'<rect x="150" y="138" width="18" height="90" fill="{CREAM}"/><rect x="188" y="138" width="18" height="90" fill="{CREAM}"/>'
    f'<rect x="62" y="230" width="166" height="16" fill="{CREAM}"/>'
    f'<rect x="150" y="214" width="110" height="70" rx="10" fill="{SUNSET}"/><rect x="150" y="230" width="110" height="12" fill="{ASPHALT}"/>'
    f'<circle cx="230" cy="214" r="22" fill="{EMBER}"/><path d="M220 204 L240 224 M240 204 L220 224" stroke="{CREAM}" stroke-width="5" stroke-linecap="round"/>')

ART['pote'] = human('#5E7A38', skin='c', hair='short', hair_col='#1C1916', top='#E9C46A',
                    hat_kind='capback', hat_col='#264653', extras=('cheeks',), props=('bag',))

ART['galere'] = scene('#8A5A2A',
    van_shape(48, 150, 1.8, body='#C9B48F') +
    f'<path d="M150 210 Q140 180 160 160 Q150 140 168 122" stroke="{DUST}" stroke-width="7" fill="none" stroke-linecap="round"/>'
    f'<path d="M226 60 L262 124 H190 Z" fill="{SUNSET}" stroke="{EMBER}" stroke-width="6" stroke-linejoin="round"/>'
    f'<path d="M226 82 V104" stroke="{ASPHALT}" stroke-width="6" stroke-linecap="round"/><circle cx="226" cy="114" r="3.5" fill="{ASPHALT}"/>')

ART['whatsapp'] = scene('#3E6A48',
    f'<circle cx="100" cy="120" r="30" fill="{CREAM}"/><path d="M50 210 Q52 160 100 158 Q148 160 150 210 Z" fill="{CREAM}"/>'
    f'<circle cx="190" cy="110" r="26" fill="{SAGE}"/><path d="M146 196 Q148 152 190 150 Q232 152 234 196 Z" fill="{SAGE}"/>'
    f'<circle cx="145" cy="170" r="28" fill="{SUNSET}"/><path d="M96 262 Q98 214 145 212 Q192 214 194 262 Z" fill="{SUNSET}"/>'
    f'<circle cx="236" cy="56" r="26" fill="{EMBER}"/><text x="236" y="64" text-anchor="middle" font-family="sans-serif" font-weight="bold" font-size="20" fill="{CREAM}">214</text>')

ART['collectionneur'] = human('#5A4232', skin='a', hair='short', hair_col='#D9D2C8', top='#2E2622',
                              extras=('monocle', 'mustache'), props=('tie',), collar=CREAM)

ART['casse'] = scene('#5A5A5A',
    ''.join(f'<ellipse cx="{x}" cy="{y}" rx="52" ry="18" fill="{ASPHALT}"/><ellipse cx="{x}" cy="{y}" rx="26" ry="8" fill="#5A5A5A"/>'
            for x, y in [(90, 250), (90, 222), (90, 194), (90, 166), (200, 250), (200, 222)]) +
    f'<g transform="translate(160 70) rotate(18)"><path d="M6 34 V14 Q6 6 14 6 H70 L92 22 Q100 24 100 32 V34 Z" fill="#8E8478"/>'
    f'<rect x="18" y="12" width="20" height="10" rx="2" fill="{ASPHALT}"/></g>'
    f'<path d="M210 150 L236 176 M236 150 L210 176" stroke="{SUNSET}" stroke-width="6" stroke-linecap="round"/>')

ART['amie'] = human('#7A5A86', skin='d', hair='curly', hair_col='#1C1916', top='#E9C46A',
                    extras=('cheeks',), props=('phone',))

ART['viticulteur'] = human('#5A3A5E', skin='e', hair='short', hair_col='#6B625A', top='#8B6A4A',
                           hat_kind='straw', hat_col='#E9C46A', extras=('beard',), props=('grapes',))

ART['ferme'] = scene('#4E6A3A',
    f'<circle cx="220" cy="70" r="30" fill="{SUNSET}"/>'
    f'<path d="M145 250 V150" stroke="{SAGE}" stroke-width="10" stroke-linecap="round"/>'
    f'<path d="M145 180 Q90 180 80 120 Q136 118 145 180 Z" fill="{SAGE}"/>'
    f'<path d="M145 156 Q196 150 210 96 Q154 98 145 156 Z" fill="#A8C98F"/>'
    f'<path d="M60 250 Q145 226 230 250" stroke="#6B4A2F" stroke-width="10" fill="none"/>')

ART['marche'] = scene('#8A6A2A',
    f'<path d="M60 70 H230 V100 H60 Z" fill="{EMBER}"/>'
    + ''.join(f'<rect x="{60 + i * 34}" y="70" width="17" height="30" fill="{CREAM}"/>' for i in range(5)) +
    f'<path d="M60 100 Q77 116 94 100 Q111 116 128 100 Q145 116 162 100 Q179 116 196 100 Q213 116 230 100" fill="{EMBER}"/>'
    f'<path d="M100 170 Q100 120 145 120 Q190 120 190 170" stroke="#6B4A2F" stroke-width="8" fill="none"/>'
    f'<path d="M80 170 H210 L194 250 H96 Z" fill="#C9934E"/>'
    f'<path d="M92 196 H198 M100 222 H190" stroke="#8B6A4A" stroke-width="4"/>'
    f'<circle cx="114" cy="166" r="14" fill="{EMBER}"/><circle cx="140" cy="160" r="15" fill="{SAGE}"/><circle cx="168" cy="166" r="13" fill="{SUNSET}"/>')

ART['controleur'] = human('#55626A', skin='a', hair='bald', hair_col='#3B2A22', top='#7E8C94',
                          extras=('glasses', 'frown'), props=('clipboard',), collar=CREAM)

ART['stoppeur'] = human('#6E5A48', skin='b', hair='midlong', hair_col='#6B4A2F', top='#2A9D8F',
                        hat_kind='beanie', hat_col=EMBER, extras=('beard',), props=('thumb',))

ART['musicien'] = human('#7A7A30', skin='c', hair='curly', hair_col='#2A1E18', top='#264653',
                        hat_kind='headphones', hat_col=ASPHALT, extras=('closed',), props=('guitar',))

ART['pecheur'] = human('#2F6670', skin='e', hair='short', hair_col='#B9AFA6', top='#E9C46A',
                       hat_kind='bucket', hat_col='#3D5A48', extras=('beard',), props=('rod',))

ART['village'] = scene('#8A4A32',
    f'<path d="M0 60 Q145 120 290 60" stroke="{CREAM}" stroke-width="3" fill="none"/>'
    + ''.join(f'<path d="M{x} {60 + (x - 145) ** 2 * -0.0028 + 60 - 60 * 0} l14 30 l14 -30 Z" fill="{c}"/>'
              for x, c in [(10, SUNSET), (46, CREAM), (82, SAGE), (118, SUNSET), (154, CREAM), (190, SAGE), (226, SUNSET), (262, CREAM)]) +
    f'<rect x="70" y="160" width="150" height="90" rx="6" fill="{CREAM}"/>'
    f'<rect x="58" y="146" width="174" height="24" rx="4" fill="{EMBER}"/>'
    f'<rect x="94" y="190" width="30" height="44" rx="4" fill="{SUNSET}"/><rect x="166" y="190" width="30" height="44" rx="4" fill="{SUNSET}"/>'
    f'<rect x="130" y="190" width="30" height="20" rx="4" fill="{ASPHALT}"/>')


# corrige la guirlande (pas de calcul approximatif dans les points)
def bunting():
    out = f'<path d="M0 50 Q145 110 290 50" stroke="{CREAM}" stroke-width="3" fill="none"/>'
    cols = [SUNSET, CREAM, SAGE]
    for i, x in enumerate(range(12, 290, 36)):
        t = x / 290
        y = (1 - t) ** 2 * 50 + 2 * (1 - t) * t * 110 + t ** 2 * 50
        out += f'<path d="M{x - 12:.1f} {y:.1f} L{x:.1f} {y + 30:.1f} L{x + 12:.1f} {y:.1f} Z" fill="{cols[i % 3]}"/>'
    return out


ART['village'] = scene('#8A4A32', bunting() +
    f'<rect x="70" y="160" width="150" height="90" rx="6" fill="{CREAM}"/>'
    f'<rect x="58" y="146" width="174" height="24" rx="4" fill="{EMBER}"/>'
    f'<rect x="94" y="190" width="30" height="44" rx="4" fill="{SUNSET}"/><rect x="166" y="190" width="30" height="44" rx="4" fill="{SUNSET}"/>'
    f'<rect x="130" y="190" width="30" height="20" rx="4" fill="{ASPHALT}"/>')


# ---------------------------------------------------------------- fins (carrées 240)
def end(inner):
    return svg(inner, 240, 180)


GROUND = f'<path d="M0 176 H240" stroke="{ASPH2}" stroke-width="4"/>'
END = {}
END['fauche'] = end(
    f'<path d="M50 70 H190 Q200 70 200 80 V150 Q200 160 190 160 H50 Q40 160 40 150 V80 Q40 70 50 70 Z" fill="#6B4A2F"/>'
    f'<path d="M40 92 H200" stroke="#4A3220" stroke-width="4"/><rect x="150" y="102" width="50" height="30" rx="8" fill="#4A3220"/>'
    f'<circle cx="164" cy="117" r="5" fill="{SUNSET}"/>'
    f'<path d="M98 30 Q110 54 100 64" stroke="{DUST}" stroke-width="3" fill="none" stroke-dasharray="4 6"/>'
    f'<circle cx="96" cy="24" r="9" fill="none" stroke="{DUST}" stroke-width="3"/>' + GROUND)
END['rentier'] = end(
    f'<path d="M40 100 L110 46 L180 100 Z" fill="{EMBER}"/><rect x="52" y="98" width="116" height="74" fill="{CREAM}"/>'
    f'<rect x="96" y="124" width="28" height="48" fill="#6B4A2F"/><rect x="64" y="112" width="22" height="20" fill="{SUNSET}"/>'
    f'<rect x="134" y="112" width="22" height="20" fill="{SUNSET}"/>' + van_shape(172, 138, 0.6, body=DUST) + GROUND)
END['blues'] = end(
    f'<circle cx="94" cy="56" r="26" fill="{DUST}"/><circle cx="134" cy="48" r="32" fill="{DUST}"/><rect x="66" y="56" width="112" height="28" rx="14" fill="{DUST}"/>'
    + ''.join(f'<path d="M{x} {y} l-6 14" stroke="#7F9AAE" stroke-width="4" stroke-linecap="round"/>' for x, y in [(80, 98), (104, 106), (128, 96), (152, 108), (172, 98), (92, 128), (140, 130)]) +
    van_shape(70, 132, 1.0, body='#6B625A') + GROUND)
END['illumination'] = end(
    f'<circle cx="120" cy="110" r="62" fill="{SUNSET}"/>'
    + ''.join(f'<path d="M120 110 L{120 + 90 * c:.1f} {110 - 90 * s:.1f}" stroke="{SUNSET}" stroke-width="3" opacity="0.5"/>'
              for c, s in [(1, 0), (0.87, 0.5), (0.5, 0.87), (0, 1), (-0.5, 0.87), (-0.87, 0.5), (-1, 0)]) +
    f'<rect x="0" y="120" width="240" height="60" fill="{ASPHALT}"/>'
    f'<circle cx="120" cy="96" r="12" fill="{ASPHALT}"/><path d="M96 130 Q98 108 120 108 Q142 108 144 130 Z" fill="{ASPHALT}"/>'
    f'<path d="M84 130 Q120 116 156 130" stroke="{ASPHALT}" stroke-width="8" fill="none" stroke-linecap="round"/>')
END['moteur_mort'] = end(
    f'<path d="M150 68 Q138 50 152 38 Q144 22 160 14" stroke="#6B625A" stroke-width="7" fill="none" stroke-linecap="round"/>'
    f'<path d="M170 70 Q182 54 172 40 Q186 28 178 16" stroke="#4A433D" stroke-width="6" fill="none" stroke-linecap="round"/>'
    + van_shape(50, 104, 1.4, body='#3A332D', win=ASPHALT) + GROUND)
END['van_musee'] = end(
    van_shape(56, 92, 1.25, body=SUNSET) +
    f'<rect x="30" y="152" width="180" height="12" rx="4" fill="{DUST}"/>'
    + ''.join(f'<path d="M{x} {y - 9} L{x + 3} {y - 3} L{x + 9} {y} L{x + 3} {y + 3} L{x} {y + 9} L{x - 3} {y + 3} L{x - 9} {y} L{x - 3} {y - 3} Z" fill="{CREAM}"/>'
              for x, y in [(44, 60), (190, 50), (210, 110), (120, 40)]) + GROUND)
END['ermite'] = end(
    ''.join(f'<path d="M{x} 176 L{x + 26} 176 L{x + 13} {176 - h} Z" fill="{c}"/>'
            for x, h, c in [(0, 110, '#3D5A48'), (22, 140, '#2F4A3A'), (52, 100, '#3D5A48'), (160, 130, '#2F4A3A'), (186, 96, '#3D5A48'), (210, 150, '#2F4A3A')]) +
    van_shape(80, 136, 0.8, body='#5E7A3E') +
    f'<circle cx="110" cy="134" r="5" fill="{SAGE}"/><circle cx="130" cy="132" r="7" fill="{SAGE}"/>' + GROUND)
END['communaute'] = end(
    f'<path d="M20 176 L60 110 L100 176 Z" fill="{EMBER}"/><path d="M140 176 L180 110 L220 176 Z" fill="{SAGE}"/>'
    f'<path d="M92 176 L120 130 L148 176 Z" fill="{SUNSET}"/>'
    f'<path d="M110 176 L120 160 L130 176 Z" fill="{ASPHALT}"/>'
    f'<path d="M104 168 L136 168 M110 160 L130 176 M130 160 L110 176" stroke="#6B4A2F" stroke-width="4"/>'
    f'<path d="M120 154 Q112 140 122 130" stroke="{SUNSET}" stroke-width="4" fill="none"/>' + GROUND)
END['cap_nord'] = end(
    f'<circle cx="120" cy="120" r="44" fill="{SUNSET}"/><rect x="0" y="122" width="240" height="58" fill="#2F4A66"/>'
    f'<path d="M20 140 H90 M140 150 H220 M60 160 H150" stroke="{SUNSET}" stroke-width="3" opacity="0.6"/>'
    f'<path d="M150 122 L176 70 L184 122 Z" fill="{DUST}"/><circle cx="176" cy="64" r="10" fill="none" stroke="{CREAM}" stroke-width="3"/>')
END['fourriere'] = end(
    f'<rect x="20" y="130" width="140" height="22" rx="4" fill="{SUNSET}"/><rect x="128" y="104" width="44" height="34" rx="6" fill="{SUNSET}"/>'
    f'<path d="M30 130 L80 86" stroke="{DUST}" stroke-width="6"/>'
    f'<g transform="translate(60 52) rotate(-24)">{van_shape(0, 0, 0.9, body=DUST)}</g>'
    f'<circle cx="46" cy="158" r="12" fill="{ASPHALT}" stroke="{CREAM}" stroke-width="3"/><circle cx="144" cy="158" r="12" fill="{ASPHALT}" stroke="{CREAM}" stroke-width="3"/>'
    f'<rect x="196" y="40" width="10" height="136" fill="{DUST}"/><circle cx="201" cy="40" r="22" fill="#2F4A88" stroke="{EMBER}" stroke-width="5"/>'
    f'<path d="M186 26 L216 54" stroke="{EMBER}" stroke-width="5"/>' + GROUND)
END['influenceur'] = end(
    f'<rect x="84" y="20" width="72" height="140" rx="14" fill="{ASPHALT}" stroke="{DUST}" stroke-width="3"/>'
    f'<rect x="92" y="32" width="56" height="112" rx="6" fill="{SUNSET}"/>'
    f'<circle cx="120" cy="74" r="14" fill="{CREAM}"/><path d="M98 120 Q100 94 120 94 Q140 94 142 120 Z" fill="{CREAM}"/>'
    f'<circle cx="46" cy="60" r="16" fill="{EMBER}"/><path d="M46 52 V68 M38 60 H54" stroke="{CREAM}" stroke-width="3"/>'
    f'<path d="M190 54 C182 44 168 54 190 72 C212 54 198 44 190 54 Z" fill="{EMBER}"/>'
    f'<path d="M178 110 C172 102 162 110 178 124 C194 110 184 102 178 110 Z" fill="{EMBER}" opacity="0.7"/>' + GROUND)
END['retour_famille'] = end(
    f'<path d="M120 30 V150" stroke="{DUST}" stroke-width="10" stroke-linecap="round"/>'
    f'<circle cx="120" cy="30" r="12" fill="none" stroke="{DUST}" stroke-width="8"/>'
    f'<path d="M92 62 H148" stroke="{DUST}" stroke-width="8" stroke-linecap="round"/>'
    f'<path d="M64 112 Q70 160 120 160 Q170 160 176 112" stroke="{DUST}" stroke-width="10" fill="none" stroke-linecap="round"/>'
    f'<path d="M56 116 L64 100 L74 118 Z M184 116 L176 100 L166 118 Z" fill="{DUST}"/>'
    f'<path d="M0 168 Q30 158 60 168 T120 168 T180 168 T240 168" stroke="#2F6670" stroke-width="5" fill="none"/>')
END['vente_sauvage'] = end(
    f'<rect x="40" y="110" width="160" height="62" rx="4" fill="none" stroke="{CREAM}" stroke-width="3" stroke-dasharray="10 8"/>'
    f'<path d="M60 172 Q100 150 120 120 Q140 90 220 80" stroke="#4A433D" stroke-width="10" fill="none"/>'
    f'<path d="M80 172 Q118 152 138 122 Q156 98 230 92" stroke="#4A433D" stroke-width="10" fill="none"/>'
    f'<text x="120" y="60" text-anchor="middle" font-family="sans-serif" font-weight="bold" font-size="40" fill="{SUNSET}">?</text>' + GROUND)


# ---------------------------------------------------------------- icônes (noir, recoloriées dans l'app)
def icon(paths):
    return ('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="#000000" '
            'stroke-width="2" stroke-linecap="round" stroke-linejoin="round">' + paths + '</svg>')


ICONS = {
    'argent': '<circle cx="12" cy="12" r="9"/><path d="M15 9.2c-.6-.8-1.6-1.2-2.6-1.2-1.9 0-3.2 1.6-3.2 4s1.3 4 3.2 4c1 0 2-.4 2.6-1.2M7.5 11h5M7.5 13h5"/>',
    'moral': '<path d="M12 3c1 3 4.5 4.6 4.5 9a4.5 4.5 0 0 1-9 0c0-2.2 1-3.4 2.2-4.4 0 1.6.9 2.7 2.1 2.7 0-2.8-1.1-4.8.2-7.3z"/>',
    'van': '<path d="M3 16V9a2 2 0 0 1 2-2h10l4.5 4.5A2 2 0 0 1 21 13v3"/><path d="M15 7v4.5h6"/><circle cx="7.5" cy="17" r="2"/><circle cx="16.5" cy="17" r="2"/><path d="M9.5 17h5"/>',
    'liens': '<circle cx="9" cy="8" r="3"/><circle cx="16.5" cy="9" r="2.5"/><path d="M3.5 20c0-3.3 2.5-6 5.5-6s5.5 2.7 5.5 6"/><path d="M15.5 14.4c2.8 0 5 2.2 5 5.6"/>',
    'chien': '<circle cx="6" cy="10" r="2"/><circle cx="10" cy="5.5" r="2"/><circle cx="15" cy="5.5" r="2"/><circle cx="19" cy="10" r="2"/><path d="M8 17c0-3 2-5.5 4.5-5.5S17 14 17 17c0 2-1.5 3-3 3h-3c-1.5 0-3-1-3-3z"/>',
    'solaire': '<circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M2 12h2M20 12h2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4"/>',
    'chauffage': '<path d="M8 21h8M10 3c-2 3 2 4 0 7M14 3c-2 3 2 4 0 7"/><rect x="5" y="13" width="14" height="5" rx="2"/>',
    'freelance': '<rect x="3" y="5" width="18" height="12" rx="2"/><path d="M1.5 20h21"/>',
    'starlink': '<path d="M5 19a9 9 0 0 1 0-13l13 13a9 9 0 0 1-13 0z"/><path d="M12 12l4-4M15 3a6 6 0 0 1 6 6M15 6.5a2.5 2.5 0 0 1 2.5 2.5"/>',
    'insta': '<rect x="3" y="3" width="18" height="18" rx="5"/><circle cx="12" cy="12" r="4"/><circle cx="17.5" cy="6.5" r="0.5"/>',
    'duo': '<path d="M12 20s-7-4.4-7-10a4 4 0 0 1 7-2.6A4 4 0 0 1 19 10c0 5.6-7 10-7 10z"/>',
    'amour': '<rect x="3" y="5" width="18" height="14" rx="2"/><path d="M3 7l9 6 9-6"/>',
    'convoi': '<rect x="2" y="7" width="12" height="9" rx="2"/><path d="M14 10h4l3 3v3h-7"/><circle cx="6" cy="17" r="1.8"/><circle cx="17" cy="17" r="1.8"/>',
    'nord': '<circle cx="12" cy="12" r="9"/><path d="M15.5 8.5l-2 5-5 2 2-5z"/>',
    'cadenas': '<rect x="5" y="11" width="14" height="10" rx="2"/><path d="M8 11V8a4 4 0 0 1 8 0v3"/>',
    'fleche': '<path d="M5 12h14M13 6l6 6-6 6"/>',
    'hiver': '<path d="M12 2v20M4.9 7l14.2 10M4.9 17L19.1 7M9 3.5l3 2 3-2M9 20.5l3-2 3 2"/>',
    'saison': '<circle cx="12" cy="12" r="4"/><path d="M12 3v2M12 19v2M3 12h2M19 12h2"/>',
}

HOME = svg(
    f'<circle cx="171" cy="120" r="78" fill="{SUNSET}"/>'
    f'<rect x="0" y="120" width="342" height="80" fill="{ASPHALT}"/>'
    f'<rect x="40" y="96" width="262" height="6" rx="3" fill="{ASPHALT}"/>'
    f'<rect x="70" y="80" width="202" height="5" rx="2.5" fill="{ASPHALT}"/>'
    f'<path d="M0 120 L342 120" stroke="{ASPH2}" stroke-width="2"/>'
    f'<path d="M171 200 L150 120 M171 200 L192 120" stroke="{ASPH2}" stroke-width="2"/>'
    f'<path d="M168 192 L170 172 M171 160 L171.5 146 M172 136 L172.3 128" stroke="{SUNSET}" stroke-width="3" stroke-linecap="round"/>'
    + van_shape(118, 84), 342, 200)

APP_ICON = svg(
    f'<rect x="0" y="0" width="512" height="512" fill="{ASPHALT}"/>'
    f'<circle cx="256" cy="300" r="150" fill="{SUNSET}"/>'
    f'<rect x="0" y="300" width="512" height="212" fill="{ASPHALT}"/>'
    f'<rect x="96" y="250" width="320" height="12" rx="6" fill="{ASPHALT}"/>'
    f'<rect x="140" y="214" width="232" height="10" rx="5" fill="{ASPHALT}"/>'
    f'<path d="M256 512 L232 300 M256 512 L280 300" stroke="{ASPH2}" stroke-width="4"/>'
    f'<path d="M254 470 L255 430 M256 400 L256.5 370 M257 348 L257 330" stroke="{SUNSET}" stroke-width="8" stroke-linecap="round"/>'
    + van_shape(136, 214, 2.4), 512, 512)


def write(path, content):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w') as f:
        f.write(content)


for k, v in ART.items():
    write(f'{OUT}/assets/characters/{k}.svg', v)
for k, v in END.items():
    write(f'{OUT}/assets/endings/{k}.svg', v)
for k, v in ICONS.items():
    write(f'{OUT}/assets/icons/{k}.svg', icon(v))
write(f'{OUT}/assets/home.svg', HOME)
write(f'{OUT}/assets/icon/icon.svg', APP_ICON)
print(len(ART), 'personnages,', len(END), 'fins,', len(ICONS), 'icônes')
