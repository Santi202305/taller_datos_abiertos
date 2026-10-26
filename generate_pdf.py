import os
import sys

# Ensure user-installed packages in .local are accessible
local_pkg = '/home/vulkan/.local/lib/python3.14/site-packages'
if local_pkg not in sys.path and os.path.exists(local_pkg):
    sys.path.insert(0, local_pkg)

from reportlab.lib.pagesizes import letter
from reportlab.lib import colors
from reportlab.lib.units import inch
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, Image, KeepTogether, PageBreak, HRFlowable
)
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.enums import TA_CENTER, TA_LEFT, TA_RIGHT, TA_JUSTIFY
from reportlab.pdfgen import canvas

class NumberedCanvas(canvas.Canvas):
    def __init__(self, *args, **kwargs):
        super(NumberedCanvas, self).__init__(*args, **kwargs)
        self._saved_page_states = []

    def showPage(self):
        self._saved_page_states.append(dict(self.__dict__))
        self._startPage()

    def save(self):
        num_pages = len(self._saved_page_states)
        for state in self._saved_page_states:
            self.__dict__.update(state)
            self.draw_page_number(num_pages)
            super(NumberedCanvas, self).showPage()
        super(NumberedCanvas, self).save()

    def draw_page_number(self, page_count):
        if self._pageNumber == 1:
            return  # Portada sin footer
        self.saveState()
        self.setFont("Helvetica", 9)
        self.setFillColor(colors.HexColor("#555555"))
        self.setStrokeColor(colors.HexColor("#D0D0D0"))
        self.setLineWidth(0.5)
        self.line(36, 40, letter[0] - 36, 40)
        self.drawString(36, 28, "Taller 4: Datos Abiertos de Colombia (Flutter) | Santiago")
        page_str = f"Página {self._pageNumber} de {page_count}"
        self.drawRightString(letter[0] - 36, 28, page_str)
        self.restoreState()

def build_pdf(filename="docs/PDF_Entrega.pdf"):
    doc = SimpleDocTemplate(
        filename,
        pagesize=letter,
        leftMargin=36,
        rightMargin=36,
        topMargin=36,
        bottomMargin=54
    )

    styles = getSampleStyleSheet()

    title_style = ParagraphStyle(
        'DocTitle',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=24,
        leading=28,
        textColor=colors.HexColor("#1565C0"),
        alignment=TA_CENTER
    )

    subtitle_style = ParagraphStyle(
        'DocSubtitle',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=13,
        leading=17,
        textColor=colors.HexColor("#424242"),
        alignment=TA_CENTER
    )

    h1_style = ParagraphStyle(
        'Heading1_Custom',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=15,
        leading=19,
        textColor=colors.HexColor("#0D47A1"),
        spaceBefore=14,
        spaceAfter=8,
        keepWithNext=True
    )

    h2_style = ParagraphStyle(
        'Heading2_Custom',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=12,
        leading=15,
        textColor=colors.HexColor("#1976D2"),
        spaceBefore=10,
        spaceAfter=6,
        keepWithNext=True
    )

    body_style = ParagraphStyle(
        'Body_Custom',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=9.5,
        leading=13.5,
        textColor=colors.HexColor("#212121"),
        alignment=TA_JUSTIFY,
        spaceAfter=6
    )

    code_style = ParagraphStyle(
        'Code_Custom',
        parent=styles['Normal'],
        fontName='Courier',
        fontSize=8,
        leading=10.5,
        textColor=colors.HexColor("#1B5E20")
    )

    caption_style = ParagraphStyle(
        'Caption_Custom',
        parent=styles['Normal'],
        fontName='Helvetica-Oblique',
        fontSize=8.5,
        leading=11,
        textColor=colors.HexColor("#455A64"),
        alignment=TA_CENTER,
        spaceBefore=3,
        spaceAfter=10
    )

    story = []

    # ==================== PORTADA ====================
    story.append(Spacer(1, 40))
    story.append(Paragraph("TALLER 4: DATOS ABIERTOS DE COLOMBIA", title_style))
    story.append(Spacer(1, 10))
    story.append(Paragraph("Desarrollo de Aplicación Móvil en Flutter con GoRouter, Arquitectura por Capas y Consumo de API REST", subtitle_style))
    story.append(Spacer(1, 18))
    story.append(HRFlowable(width="90%", thickness=2, color=colors.HexColor("#1565C0"), spaceAfter=25, spaceBefore=5))

    cover_data = [
        [Paragraph("<b>Estudiante / Desarrollador:</b>", body_style), Paragraph("[NOMBRE COMPLETO]", body_style)],
        [Paragraph("<b>Código Estudiantil:</b>", body_style), Paragraph("[CÓDIGO]", body_style)],
        [Paragraph("<b>Programa / Asignatura:</b>", body_style), Paragraph("[PROGRAMA/CURSO]", body_style)],
        [Paragraph("<b>Repositorio GitHub:</b>", body_style), Paragraph('<font color="#1565C0"><u>https://github.com/Santi202305/taller_datos_abiertos.git</u></font>', body_style)],
        [Paragraph("<b>Ramas Versionadas:</b>", body_style), Paragraph("<code>main</code>, <code>dev</code>, <code>feature/taller_api_colombia</code>", body_style)],
        [Paragraph("<b>Fecha de Entrega:</b>", body_style), Paragraph("Octubre 2026", body_style)],
    ]

    cover_table = Table(cover_data, colWidths=[180, 340])
    cover_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, -1), colors.HexColor("#F5F7FA")),
        ('BOX', (0, 0), (-1, -1), 1, colors.HexColor("#B0BEC5")),
        ('INNERGRID', (0, 0), (-1, -1), 0.5, colors.HexColor("#E0E0E0")),
        ('TOPPADDING', (0, 0), (-1, -1), 8),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 8),
        ('LEFTPADDING', (0, 0), (-1, -1), 12),
        ('RIGHTPADDING', (0, 0), (-1, -1), 12),
    ]))
    story.append(cover_table)

    story.append(Spacer(1, 35))

    abstract_text = (
        "<b>Resumen del Proyecto:</b><br/>"
        "Este informe documenta la solución completa al Taller 4: Datos Abiertos de Colombia. "
        "La aplicación móvil desarrollada en Flutter consume 5 endpoints de la API oficial de Colombia "
        "(https://api-colombia.com/api/v1/), implementando un Dashboard interactivo, vistas de Listado "
        "con ListView.builder y vistas de Detalle completo con soporte maestro-detalle. "
        "La arquitectura desacopla estrictamente configuración (.env), modelos con fromJson/toJson, "
        "servicios HTTP con validación robusta de estado, tema global Material 3, enrutamiento declarativo "
        "con go_router y widgets de estado asíncrono (cargando, éxito, error con reintento y vacío)."
    )
    story.append(Paragraph(abstract_text, body_style))
    story.append(PageBreak())

    # ==================== SECCIÓN 1: ENDPOINTS CONSUMIDOS ====================
    story.append(Paragraph("1. Descripción de la API y Endpoints Seleccionados", h1_style))
    story.append(Paragraph(
        "Se consultó la API pública oficial de la República de Colombia "
        "(<b>https://api-colombia.com/api/v1/</b>) documentada en Swagger. "
        "Se verificaron mediante peticiones HTTP reales 5 endpoints que devuelven listas estructuradas con identificador único:",
        body_style
    ))

    endpoints_data = [
        [Paragraph("<b>Endpoint</b>", body_style), Paragraph("<b>Descripción</b>", body_style), Paragraph("<b>Campos Clave</b>", body_style)],
        [Paragraph("<code>/Department</code>", code_style), Paragraph("Departamentos de Colombia, capitales, población y superficie.", body_style), Paragraph("id, name, population, surface, municipalities, phonePrefix", code_style)],
        [Paragraph("<code>/President</code>", code_style), Paragraph("Presidentes históricos, periodo de gobierno y partido político.", body_style), Paragraph("id, name, lastName, politicalParty, start/endPeriodDate", code_style)],
        [Paragraph("<code>/TouristicAttraction</code>", code_style), Paragraph("Sitios turísticos de interés nacional, fotos y coordenadas.", body_style), Paragraph("id, name, description, latitude, longitude, images", code_style)],
        [Paragraph("<code>/Region</code>", code_style), Paragraph("Regiones naturales y geográficas colombianas.", body_style), Paragraph("id, name, description", code_style)],
        [Paragraph("<code>/TypicalDish</code>", code_style), Paragraph("Gastronomía típica, ingredientes y departamento de origen.", body_style), Paragraph("id, name, description, ingredients, imageUrl", code_style)],
    ]
    ep_table = Table(endpoints_data, colWidths=[120, 240, 180])
    ep_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor("#E3F2FD")),
        ('BOX', (0, 0), (-1, -1), 1, colors.HexColor("#90CAF9")),
        ('INNERGRID', (0, 0), (-1, -1), 0.5, colors.HexColor("#E0E0E0")),
        ('TOPPADDING', (0, 0), (-1, -1), 5),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 5),
    ]))
    story.append(ep_table)
    story.append(Spacer(1, 12))

    # ==================== SECCIÓN 2: ARQUITECTURA Y PAQUETES ====================
    story.append(Paragraph("2. Arquitectura del Proyecto y Paquetes", h1_style))
    story.append(Paragraph(
        "El proyecto respeta la estructura modular por capas requerida en el taller:",
        body_style
    ))

    arch_data = [
        [Paragraph("<b>Directorio</b>", body_style), Paragraph("<b>Propósito y Responsabilidad</b>", body_style)],
        [Paragraph("<code>lib/config/</code>", code_style), Paragraph("Centraliza la lectura de variables de entorno mediante <code>EnvConfig</code>.", body_style)],
        [Paragraph("<code>lib/models/</code>", code_style), Paragraph("Modelos fuertemente tipados con constructores <code>fromJson</code> y <code>toJson</code> para cada entidad.", body_style)],
        [Paragraph("<code>lib/routes/</code>", code_style), Paragraph("Configuración de <code>GoRouter</code> con rutas nombradas, parámetros de URL y pantalla de fallback.", body_style)],
        [Paragraph("<code>lib/services/</code>", code_style), Paragraph("Capa de comunicación HTTP con <code>ApiService</code> genérico, decodificación UTF-8, timeout y captura de errores.", body_style)],
        [Paragraph("<code>lib/themes/</code>", code_style), Paragraph("Configuración de <code>ThemeData</code> global con Material 3, paleta institucional y tipografías.", body_style)],
        [Paragraph("<code>lib/views/</code>", code_style), Paragraph("Pantallas principales: <code>DashboardView</code>, <code>EndpointListView</code> y <code>DetailView</code>.", body_style)],
        [Paragraph("<code>lib/widgets/</code>", code_style), Paragraph("Componentes desacoplados: tarjetas de dashboard, items de lista, estados de carga, error y vacío.", body_style)],
    ]
    arch_table = Table(arch_data, colWidths=[130, 410])
    arch_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor("#E8F5E9")),
        ('BOX', (0, 0), (-1, -1), 1, colors.HexColor("#A5D6A7")),
        ('INNERGRID', (0, 0), (-1, -1), 0.5, colors.HexColor("#E0E0E0")),
        ('TOPPADDING', (0, 0), (-1, -1), 4),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 4),
    ]))
    story.append(arch_table)
    story.append(Spacer(1, 8))

    story.append(Paragraph("<b>Paquetes Implementados:</b>", h2_style))
    story.append(Paragraph("• <b>http (^1.6.0):</b> Consumo de servicios REST con validación de status code, decodificación UTF-8 para soporte de tildes y eñes, y timeouts de 15 segundos.<br/>"
                           "• <b>go_router (^18.1.1):</b> Enrutador declarativo con rutas nombradas, paso de parámetros por URL (<code>pathParameters</code>) y manejo de fallback.<br/>"
                           "• <b>flutter_dotenv (^6.0.1):</b> Desacoplamiento de la <code>BASE_URL</code> en archivo <code>.env</code> integrado a los assets de la app.", body_style))

    # ==================== SECCIÓN 3: RUTAS DE GO_ROUTER ====================
    story.append(Spacer(1, 8))
    story.append(Paragraph("3. Tabla de Rutas Implementadas (GoRouter)", h1_style))
    routes_data = [
        [Paragraph("<b>Nombre (name)</b>", body_style), Paragraph("<b>Ruta (path)</b>", body_style), Paragraph("<b>Parámetros</b>", body_style), Paragraph("<b>Descripción</b>", body_style)],
        [Paragraph("<code>dashboard</code>", code_style), Paragraph("<code>/</code>", code_style), Paragraph("Ninguno", body_style), Paragraph("Dashboard principal con tarjetas de selección.", body_style)],
        [Paragraph("<code>list</code>", code_style), Paragraph("<code>/list/:endpoint</code>", code_style), Paragraph("<code>endpoint</code> (String)", code_style), Paragraph("Listado con ListView.builder y estados asíncronos.", body_style)],
        [Paragraph("<code>detail</code>", code_style), Paragraph("<code>/detail/:endpoint/:id</code>", code_style), Paragraph("<code>endpoint</code>, <code>id</code>", code_style), Paragraph("Detalle completo. Funciona con <code>extra</code> o mediante fetch por ID.", body_style)],
    ]
    routes_table = Table(routes_data, colWidths=[90, 130, 120, 200])
    routes_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor("#FFF3E0")),
        ('BOX', (0, 0), (-1, -1), 1, colors.HexColor("#FFCC80")),
        ('INNERGRID', (0, 0), (-1, -1), 0.5, colors.HexColor("#E0E0E0")),
        ('TOPPADDING', (0, 0), (-1, -1), 4),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 4),
    ]))
    story.append(routes_table)

    story.append(PageBreak())

    # ==================== SECCIÓN 4: EVIDENCIA GITFLOW ====================
    story.append(Paragraph("4. Evidencia de Flujo GitFlow y Ramas", h1_style))
    story.append(Paragraph(
        "Se adoptó la metodología GitFlow respetando las ramas solicitadas en el taller:",
        body_style
    ))
    story.append(Paragraph(
        "• <b>main:</b> Rama estable de producción.<br/>"
        "• <b>dev:</b> Rama de integración continua.<br/>"
        "• <b>feature/taller_api_colombia:</b> Rama de trabajo donde se desarrollaron todas las funcionalidades del taller con commits atómicos.",
        body_style
    ))
    story.append(Spacer(1, 6))

    git_summary = (
        "<b>Historial de Commits Atómicos Realizados:</b><br/>"
        "<font face='Courier' size='7.5'>"
        "• docs: documentacion completa, capturas y PDF de entrega<br/>"
        "• test: pruebas de widgets y generacion de capturas de pantalla<br/>"
        "• feat: vistas de dashboard, listado y detalle con manejo de estados<br/>"
        "• feat: rutas nombradas con go_router y punto de entrada<br/>"
        "• feat: widgets reutilizables de estado y tarjetas<br/>"
        "• feat: tema visual Material 3 personalizado<br/>"
        "• feat: servicio generico de API y manejo de excepciones<br/>"
        "• feat: modelos de datos con fromJson y toJson<br/>"
        "• chore: configuracion de dependencias, assets y variables de entorno<br/>"
        "• chore: inicializacion del proyecto Flutter base"
        "</font>"
    )
    story.append(Paragraph(git_summary, body_style))
    story.append(Spacer(1, 14))

    # ==================== SECCIÓN 5: CAPTURAS DE PANTALLA ====================
    story.append(Paragraph("5. Evidencias Visuales de la Aplicación", h1_style))
    story.append(Paragraph(
        "Las siguientes capturas demuestran el funcionamiento integral de la aplicación, el renderizado de datos reales y el manejo de los diferentes estados de la interfaz:",
        body_style
    ))
    story.append(Spacer(1, 6))

    def add_image_pair(img_path1, caption1, img_path2, caption2):
        img_w = 230
        img_h = 408
        im1 = Image(img_path1, width=img_w, height=img_h) if os.path.exists(img_path1) else Paragraph("Imagen no encontrada", body_style)
        im2 = Image(img_path2, width=img_w, height=img_h) if os.path.exists(img_path2) else Paragraph("Imagen no encontrada", body_style)

        table_data = [
            [im1, im2],
            [Paragraph(caption1, caption_style), Paragraph(caption2, caption_style)]
        ]
        t = Table(table_data, colWidths=[270, 270])
        t.setStyle(TableStyle([
            ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
            ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
            ('LEFTPADDING', (0, 0), (-1, -1), 0),
            ('RIGHTPADDING', (0, 0), (-1, -1), 0),
            ('TOPPADDING', (0, 0), (-1, -1), 2),
            ('BOTTOMPADDING', (0, 0), (-1, -1), 4),
        ]))
        return t

    # Par 1: Dashboard y Listado Departamentos
    story.append(add_image_pair(
        "docs/screenshots/01-dashboard.png", "Figura 1: Dashboard principal con tarjetas de selección",
        "docs/screenshots/02-listado-department.png", "Figura 2: Listado de Departamentos con datos de población"
    ))
    story.append(PageBreak())

    # Par 2: Detalle Departamentos y Listado Presidentes
    story.append(add_image_pair(
        "docs/screenshots/03-detalle-department.png", "Figura 3: Detalle de Departamento (Arauca)",
        "docs/screenshots/02-listado-president.png", "Figura 4: Listado de Presidentes de Colombia"
    ))
    story.append(PageBreak())

    # Par 3: Detalle Presidentes y Listado Atracciones
    story.append(add_image_pair(
        "docs/screenshots/03-detalle-president.png", "Figura 5: Detalle de Presidente (Rafael Núñez)",
        "docs/screenshots/02-listado-touristicattraction.png", "Figura 6: Listado de Atracciones Turísticas"
    ))
    story.append(PageBreak())

    # Par 4: Detalle Atracciones y Listado Regiones
    story.append(add_image_pair(
        "docs/screenshots/03-detalle-touristicattraction.png", "Figura 7: Detalle de Atracción (Hacienda Nápoles)",
        "docs/screenshots/02-listado-region.png", "Figura 8: Listado de Regiones Naturales"
    ))
    story.append(PageBreak())

    # Par 5: Detalle Regiones y Listado Platos Típicos
    story.append(add_image_pair(
        "docs/screenshots/03-detalle-region.png", "Figura 9: Detalle de Región Natural (Caribe)",
        "docs/screenshots/02-listado-typicaldish.png", "Figura 10: Listado de Platos Típicos Colombianos"
    ))
    story.append(PageBreak())

    # Par 6: Detalle Platos Típicos y Estado Cargando
    story.append(add_image_pair(
        "docs/screenshots/03-detalle-typicaldish.png", "Figura 11: Detalle de Plato Típico (Bandeja Paisa)",
        "docs/screenshots/04-estado-carga.png", "Figura 12: Estado Asíncrono de Carga (CircularProgressIndicator)"
    ))
    story.append(PageBreak())

    # Par 7: Estado Error y Estado Vacío
    story.append(add_image_pair(
        "docs/screenshots/05-estado-error.png", "Figura 13: Estado de Error con Botón Reintentar",
        "docs/screenshots/06-estado-vacio.png", "Figura 14: Estado de Lista Vacía Informativo"
    ))

    # Construir documento
    doc.build(story, canvasmaker=NumberedCanvas)
    print(f"PDF generado exitosamente en: {filename}")

if __name__ == "__main__":
    build_pdf()
