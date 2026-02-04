---
name: tk:workflow
description: Generate visual workflow documentation. /tk:workflow light|medium|heavy [context]
allowed-tools:
  - Read
  - Write
  - Bash
  - SubAgent
  - WebSearch
---

# /tk:workflow [mode] [context]

Generate comprehensive, self-contained HTML documentation with visual workflow diagrams, OSI model analysis, analytical charts, and dual-view output (Full + Executive). Perfect for team understanding, onboarding, and executive briefings.

## Use Cases

- Team doesn't understand how a system/feature works
- Onboarding new developers
- Executive briefings on technical systems
- Architecture reviews
- Pre-refactor analysis
- Knowledge transfer
- Network/system layer analysis

## Output Structure

**Two interconnected HTML pages:**
1. `workflow-full.html` - Complete analytical documentation
2. `workflow-executive.html` - Condensed executive summary

Both pages include:
- Navigation link to the other view at the top
- "Export to PDF" button
- Self-contained styling (no external dependencies)

---

## Process

### 1. Analyze Target

**MANDATORY: Load ALL TK Context Files**

Before generating ANY documentation, recursively read all TK-generated context. This is critical - these files contain the project's institutional knowledge.

```bash
# Determine what we're documenting
# - If [context] mentions specific files/features, focus there
# - If no context, analyze the entire project using ALL available context

# ===========================================
# STEP 1: Load ROOT context files
# ===========================================
[ -f "AGENTS.md" ] && cat AGENTS.md           # Primary project knowledge base
[ -f "README.md" ] && cat README.md           # Project overview

# ===========================================
# STEP 2: Load .tk/ directory (TK runtime state)
# ===========================================
[ -d ".tk" ] && echo "=== .tk/ Context Found ==="

# Rules that govern all agents
[ -f ".tk/RULES.md" ] && cat .tk/RULES.md

# Version history and changelog
[ -f ".tk/VERSION" ] && cat .tk/VERSION

# Multi-agent coordination logs
[ -f ".tk/COORDINATION.md" ] && cat .tk/COORDINATION.md

# Map file if exists
[ -f ".tk/MAP.md" ] && cat .tk/MAP.md

# Per-agent logs (read all, they contain execution history)
if [ -d ".tk/agents" ]; then
    echo "=== Agent Logs ==="
    for f in .tk/agents/*.md; do
        [ -f "$f" ] && echo "--- $f ---" && cat "$f"
    done
fi

# ===========================================
# STEP 3: Load .planning/ directory (Project planning state)
# ===========================================
[ -d ".planning" ] && echo "=== .planning/ Context Found ==="

# Current work state
[ -f ".planning/STATE.md" ] && cat .planning/STATE.md

# Work history log
[ -f ".planning/HISTORY.md" ] && cat .planning/HISTORY.md

# Known issues and bugs
[ -f ".planning/ISSUES.md" ] && cat .planning/ISSUES.md

# Architecture decisions with rationale
[ -f ".planning/DECISIONS.md" ] && cat .planning/DECISIONS.md

# Complete codebase file map
[ -f ".planning/CODEBASE.md" ] && cat .planning/CODEBASE.md

# System architecture documentation
[ -f ".planning/ARCHITECTURE.md" ] && cat .planning/ARCHITECTURE.md

# Discovered patterns and conventions
[ -f ".planning/PATTERNS.md" ] && cat .planning/PATTERNS.md

# ===========================================
# STEP 4: Load source code context
# ===========================================
[ -f "package.json" ] && cat package.json | head -50
find . -name "*.ts" -o -name "*.tsx" -o -name "*.js" | grep -v node_modules | head -50

# ===========================================
# STEP 5: Check for existing docs
# ===========================================
ls docs/ 2>/dev/null
[ -d "docs" ] && find docs/ -name "*.md" -exec cat {} \;
```

**Context Priority Order:**
1. `.planning/ARCHITECTURE.md` - Use this for system diagrams
2. `.planning/CODEBASE.md` - Use this for file/component references
3. `.planning/PATTERNS.md` - Use this for conventions and examples
4. `.planning/DECISIONS.md` - Use this for "why" explanations
5. `AGENTS.md` - Use this for project overview
6. `.tk/RULES.md` - Use this for constraints/guidelines
7. `.planning/ISSUES.md` - Use this for improvement recommendations
8. `.planning/HISTORY.md` - Use this for timeline/evolution

---

### 2. Mode Execution

**LIGHT (Quick Overview):**
Generate single HTML file with:
- System overview section
- One main SVG flow diagram
- Key components list
- Basic how-it-works explanation
- Output: `workflow-overview.html`

**MEDIUM (Detailed Analysis):**
Generate two HTML files:
- `workflow-full.html` - Complete documentation
- `workflow-executive.html` - Executive summary
Both with navigation links and PDF export

**HEAVY (Full Documentation + Analysis):**
```
SubAgent 1 (Mapper): Deep-dive code analysis, identify all flows, entry points, dependencies
SubAgent 2 (Diagrammer): Create comprehensive SVG diagrams (architecture, sequence, data flow, OSI model)
SubAgent 3 (Analyst): Generate analytical charts (line graphs, pie charts, sparklines)
SubAgent 4 (OSI Specialist): Map all components to OSI layers with detailed analysis
SubAgent 5 (Metrics): Gather quantitative data for charts
SubAgent DOCS: Compile everything into polished dual-page HTML output
```

---

### 3. MANDATORY: OSI Model Analysis

**For MEDIUM and HEAVY modes, generate a dedicated OSI Model section.**

Map every component to its operating OSI layer(s). Many components span multiple layers.

**OSI Layer Reference:**
| Layer | Name | Examples |
|-------|------|----------|
| 7 | Application | HTTP, REST APIs, GraphQL, WebSocket handlers, UI components |
| 6 | Presentation | JSON serialization, encryption/TLS termination, data transformation |
| 5 | Session | Authentication, session management, connection pooling |
| 4 | Transport | TCP/UDP handling, load balancers, port management |
| 3 | Network | IP routing, DNS resolution, CDN edge nodes |
| 2 | Data Link | MAC addressing, switches, network interface config |
| 1 | Physical | Hardware, cables, wireless signals |

**OSI Diagram Template:**
```svg
<svg viewBox="0 0 900 500" xmlns="http://www.w3.org/2000/svg">
  <!-- Background -->
  <rect width="900" height="500" fill="#f8fafc" rx="8"/>
  
  <!-- Title -->
  <text x="450" y="30" text-anchor="middle" font-size="18" font-weight="600" fill="#1e293b">OSI Model Component Mapping</text>
  
  <!-- Layer boxes - left side -->
  <g id="osi-layers">
    <!-- Layer 7 - Application -->
    <rect x="20" y="50" width="200" height="55" rx="6" fill="#3b82f6"/>
    <text x="120" y="75" text-anchor="middle" fill="white" font-weight="600">Layer 7</text>
    <text x="120" y="92" text-anchor="middle" fill="white" font-size="12">Application</text>
    
    <!-- Layer 6 - Presentation -->
    <rect x="20" y="110" width="200" height="55" rx="6" fill="#6366f1"/>
    <text x="120" y="135" text-anchor="middle" fill="white" font-weight="600">Layer 6</text>
    <text x="120" y="152" text-anchor="middle" fill="white" font-size="12">Presentation</text>
    
    <!-- Layer 5 - Session -->
    <rect x="20" y="170" width="200" height="55" rx="6" fill="#8b5cf6"/>
    <text x="120" y="195" text-anchor="middle" fill="white" font-weight="600">Layer 5</text>
    <text x="120" y="212" text-anchor="middle" fill="white" font-size="12">Session</text>
    
    <!-- Layer 4 - Transport -->
    <rect x="20" y="230" width="200" height="55" rx="6" fill="#a855f7"/>
    <text x="120" y="255" text-anchor="middle" fill="white" font-weight="600">Layer 4</text>
    <text x="120" y="272" text-anchor="middle" fill="white" font-size="12">Transport</text>
    
    <!-- Layer 3 - Network -->
    <rect x="20" y="290" width="200" height="55" rx="6" fill="#d946ef"/>
    <text x="120" y="315" text-anchor="middle" fill="white" font-weight="600">Layer 3</text>
    <text x="120" y="332" text-anchor="middle" fill="white" font-size="12">Network</text>
    
    <!-- Layer 2 - Data Link -->
    <rect x="20" y="350" width="200" height="55" rx="6" fill="#ec4899"/>
    <text x="120" y="375" text-anchor="middle" fill="white" font-weight="600">Layer 2</text>
    <text x="120" y="392" text-anchor="middle" fill="white" font-size="12">Data Link</text>
    
    <!-- Layer 1 - Physical -->
    <rect x="20" y="410" width="200" height="55" rx="6" fill="#f43f5e"/>
    <text x="120" y="435" text-anchor="middle" fill="white" font-weight="600">Layer 1</text>
    <text x="120" y="452" text-anchor="middle" fill="white" font-size="12">Physical</text>
  </g>
  
  <!-- Component mapping area - right side -->
  <g id="components">
    <!-- Draw component boxes aligned with their layers -->
    <!-- Connect with lines using stroke only, fill="none" -->
    <!-- Example: -->
    <rect x="280" y="55" width="150" height="40" rx="4" fill="#dbeafe" stroke="#3b82f6" stroke-width="2"/>
    <text x="355" y="80" text-anchor="middle" fill="#1e40af" font-size="12">[Component Name]</text>
    <path d="M220 77 L280 77" stroke="#3b82f6" stroke-width="2" fill="none"/>
  </g>
</svg>
```

**For each component, document:**
1. Which layer(s) it operates on
2. What it does at each layer
3. How it interacts with adjacent layers
4. Performance characteristics at each layer

---

### 4. MANDATORY: Analytical Charts

**Generate these chart types using pure SVG (no external libraries):**

#### A. Pie Chart (Component Distribution)
```svg
<svg viewBox="0 0 400 300" xmlns="http://www.w3.org/2000/svg">
  <text x="200" y="25" text-anchor="middle" font-size="16" font-weight="600" fill="#1e293b">Component Distribution by Type</text>
  
  <!-- Pie slices using path arcs - ALWAYS set fill explicitly -->
  <!-- Calculate arc paths: M cx cy L startX startY A rx ry rotation large-arc sweep endX endY Z -->
  <path d="M200 150 L200 70 A80 80 0 0 1 280 150 Z" fill="#3b82f6"/>
  <path d="M200 150 L280 150 A80 80 0 0 1 200 230 Z" fill="#22c55e"/>
  <path d="M200 150 L200 230 A80 80 0 0 1 120 150 Z" fill="#f59e0b"/>
  <path d="M200 150 L120 150 A80 80 0 0 1 200 70 Z" fill="#8b5cf6"/>
  
  <!-- Legend -->
  <rect x="300" y="80" width="12" height="12" fill="#3b82f6" rx="2"/>
  <text x="318" y="91" font-size="11" fill="#64748b">Frontend (25%)</text>
  
  <rect x="300" y="100" width="12" height="12" fill="#22c55e" rx="2"/>
  <text x="318" y="111" font-size="11" fill="#64748b">Backend (25%)</text>
  
  <rect x="300" y="120" width="12" height="12" fill="#f59e0b" rx="2"/>
  <text x="318" y="131" font-size="11" fill="#64748b">Database (25%)</text>
  
  <rect x="300" y="140" width="12" height="12" fill="#8b5cf6" rx="2"/>
  <text x="318" y="151" font-size="11" fill="#64748b">Services (25%)</text>
</svg>
```

#### B. Line Graph (Complexity/Dependencies over time)
```svg
<svg viewBox="0 0 500 250" xmlns="http://www.w3.org/2000/svg">
  <text x="250" y="20" text-anchor="middle" font-size="14" font-weight="600" fill="#1e293b">Complexity Trend</text>
  
  <!-- Grid lines - stroke only -->
  <g stroke="#e2e8f0" stroke-width="1" fill="none">
    <path d="M50 40 L50 200"/>
    <path d="M50 200 L450 200"/>
    <!-- Horizontal grid -->
    <path d="M50 80 L450 80" stroke-dasharray="4"/>
    <path d="M50 120 L450 120" stroke-dasharray="4"/>
    <path d="M50 160 L450 160" stroke-dasharray="4"/>
  </g>
  
  <!-- Axis labels -->
  <text x="45" y="45" text-anchor="end" font-size="10" fill="#64748b">High</text>
  <text x="45" y="205" text-anchor="end" font-size="10" fill="#64748b">Low</text>
  
  <!-- Data line - stroke only, NO fill -->
  <path d="M70 180 L130 160 L190 140 L250 120 L310 100 L370 90 L430 85" 
        stroke="#3b82f6" stroke-width="3" fill="none" stroke-linecap="round" stroke-linejoin="round"/>
  
  <!-- Data points -->
  <circle cx="70" cy="180" r="4" fill="#3b82f6"/>
  <circle cx="130" cy="160" r="4" fill="#3b82f6"/>
  <circle cx="190" cy="140" r="4" fill="#3b82f6"/>
  <circle cx="250" cy="120" r="4" fill="#3b82f6"/>
  <circle cx="310" cy="100" r="4" fill="#3b82f6"/>
  <circle cx="370" cy="90" r="4" fill="#3b82f6"/>
  <circle cx="430" cy="85" r="4" fill="#3b82f6"/>
</svg>
```

#### C. Sparklines (Inline metrics)
```svg
<!-- Compact sparkline for inline use -->
<svg viewBox="0 0 100 30" xmlns="http://www.w3.org/2000/svg">
  <path d="M5 25 L15 20 L25 22 L35 15 L45 18 L55 10 L65 12 L75 8 L85 5 L95 7" 
        stroke="#22c55e" stroke-width="2" fill="none" stroke-linecap="round"/>
</svg>
```

#### D. Bar Chart (Layer distribution)
```svg
<svg viewBox="0 0 400 200" xmlns="http://www.w3.org/2000/svg">
  <text x="200" y="20" text-anchor="middle" font-size="14" font-weight="600" fill="#1e293b">Components per OSI Layer</text>
  
  <!-- Bars -->
  <rect x="40" y="50" width="40" height="120" fill="#3b82f6" rx="4"/>
  <rect x="90" y="80" width="40" height="90" fill="#6366f1" rx="4"/>
  <rect x="140" y="100" width="40" height="70" fill="#8b5cf6" rx="4"/>
  <rect x="190" y="70" width="40" height="100" fill="#a855f7" rx="4"/>
  <rect x="240" y="130" width="40" height="40" fill="#d946ef" rx="4"/>
  <rect x="290" y="150" width="40" height="20" fill="#ec4899" rx="4"/>
  <rect x="340" y="160" width="40" height="10" fill="#f43f5e" rx="4"/>
  
  <!-- Labels -->
  <text x="60" y="185" text-anchor="middle" font-size="10" fill="#64748b">L7</text>
  <text x="110" y="185" text-anchor="middle" font-size="10" fill="#64748b">L6</text>
  <text x="160" y="185" text-anchor="middle" font-size="10" fill="#64748b">L5</text>
  <text x="210" y="185" text-anchor="middle" font-size="10" fill="#64748b">L4</text>
  <text x="260" y="185" text-anchor="middle" font-size="10" fill="#64748b">L3</text>
  <text x="310" y="185" text-anchor="middle" font-size="10" fill="#64748b">L2</text>
  <text x="360" y="185" text-anchor="middle" font-size="10" fill="#64748b">L1</text>
</svg>
```

**Metrics to visualize:**
- Component count by type (pie)
- Component count by OSI layer (bar)
- Dependency complexity (line)
- Code distribution (pie)
- API endpoint count by category (bar)
- Test coverage trend (line + sparkline)

---

### 5. Dual-Page HTML Structure

**Generate TWO HTML files that link to each other:**

#### File 1: `workflow-full.html` (Complete Analysis)

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Workflow Analysis: [PROJECT_NAME]</title>
    <style>
        /* === BASE STYLES === */
        :root {
            --primary: #2563eb;
            --secondary: #64748b;
            --bg: #ffffff;
            --bg-alt: #f8fafc;
            --text: #1e293b;
            --border: #e2e8f0;
            --success: #22c55e;
            --warning: #f59e0b;
            --error: #ef4444;
            --purple: #8b5cf6;
        }
        
        * { box-sizing: border-box; margin: 0; padding: 0; }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            line-height: 1.6;
            color: var(--text);
            background: var(--bg);
            max-width: 1400px;
            margin: 0 auto;
            padding: 2rem;
        }
        
        /* === TOP NAVIGATION BAR === */
        .top-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 1.5rem;
            background: var(--bg-alt);
            border: 1px solid var(--border);
            border-radius: 8px;
            margin-bottom: 2rem;
        }
        
        .view-toggle {
            display: flex;
            gap: 0.5rem;
        }
        
        .view-toggle a, .view-toggle button {
            padding: 0.5rem 1rem;
            border-radius: 6px;
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 500;
            cursor: pointer;
            border: none;
        }
        
        .view-toggle a.active {
            background: var(--primary);
            color: white;
        }
        
        .view-toggle a:not(.active) {
            background: white;
            color: var(--text);
            border: 1px solid var(--border);
        }
        
        .view-toggle a:not(.active):hover {
            background: var(--bg-alt);
        }
        
        .btn-pdf {
            background: var(--success);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .btn-pdf:hover {
            background: #16a34a;
        }
        
        /* === HEADER === */
        .header {
            border-bottom: 3px solid var(--primary);
            padding-bottom: 2rem;
            margin-bottom: 3rem;
        }
        
        .header h1 { font-size: 2.5rem; margin-bottom: 0.5rem; }
        .header .meta { color: var(--secondary); font-size: 0.9rem; }
        
        /* === SECTIONS === */
        section {
            margin-bottom: 4rem;
            scroll-margin-top: 2rem;
        }
        
        section h2 {
            font-size: 1.8rem;
            border-bottom: 2px solid var(--border);
            padding-bottom: 0.5rem;
            margin-bottom: 1.5rem;
        }
        
        /* === DIAGRAM CONTAINERS === */
        .diagram-container {
            background: var(--bg-alt);
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 2rem;
            margin: 1.5rem 0;
            overflow-x: auto;
        }
        
        .diagram-container svg {
            display: block;
            margin: 0 auto;
            max-width: 100%;
            height: auto;
        }
        
        .diagram-caption {
            text-align: center;
            color: var(--secondary);
            font-size: 0.9rem;
            margin-top: 1rem;
            font-style: italic;
        }
        
        /* === CHARTS GRID === */
        .charts-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 2rem;
            margin: 2rem 0;
        }
        
        .chart-card {
            background: white;
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 1.5rem;
        }
        
        .chart-card h4 {
            font-size: 1rem;
            margin-bottom: 1rem;
            color: var(--text);
        }
        
        /* === OSI SECTION === */
        .osi-analysis {
            background: linear-gradient(135deg, #f5f3ff 0%, #ede9fe 100%);
            border: 2px solid var(--purple);
            border-radius: 12px;
            padding: 2rem;
            margin: 2rem 0;
        }
        
        .osi-analysis h3 {
            color: var(--purple);
            margin-bottom: 1rem;
        }
        
        .osi-layer-detail {
            background: white;
            border-radius: 8px;
            padding: 1rem;
            margin: 1rem 0;
            border-left: 4px solid var(--purple);
        }
        
        /* === METRICS ROW === */
        .metrics-row {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            margin: 1.5rem 0;
        }
        
        .metric-card {
            flex: 1;
            min-width: 150px;
            background: white;
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 1rem;
            text-align: center;
        }
        
        .metric-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary);
        }
        
        .metric-label {
            font-size: 0.85rem;
            color: var(--secondary);
        }
        
        .metric-sparkline {
            margin-top: 0.5rem;
        }
        
        /* === TABLES === */
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 1.5rem 0;
        }
        
        th, td {
            text-align: left;
            padding: 0.75rem 1rem;
            border-bottom: 1px solid var(--border);
        }
        
        th { background: var(--bg-alt); font-weight: 600; }
        tr:hover { background: var(--bg-alt); }
        
        /* === PRINT/PDF STYLES === */
        @media print {
            .top-nav { display: none; }
            body { max-width: none; padding: 1cm; }
            section { break-inside: avoid; }
            .diagram-container { break-inside: avoid; }
            .charts-grid { break-inside: avoid; }
        }
    </style>
</head>
<body>
    <!-- TOP NAVIGATION -->
    <nav class="top-nav">
        <div class="view-toggle">
            <a href="workflow-full.html" class="active">Full Analysis</a>
            <a href="workflow-executive.html">Executive Summary</a>
        </div>
        <button class="btn-pdf" onclick="window.print()">
            <span>Export to PDF</span>
        </button>
    </nav>

    <!-- HEADER -->
    <header class="header">
        <h1>Workflow Analysis: [PROJECT_NAME]</h1>
        <div class="meta">
            Generated: [DATE] | Version: [VERSION] | Mode: [MODE] | Full Analysis View
        </div>
    </header>
    
    <!-- KEY METRICS ROW -->
    <section id="metrics">
        <h2>Key Metrics</h2>
        <div class="metrics-row">
            <div class="metric-card">
                <div class="metric-value">[N]</div>
                <div class="metric-label">Total Components</div>
                <div class="metric-sparkline">
                    <!-- Inline sparkline SVG -->
                </div>
            </div>
            <div class="metric-card">
                <div class="metric-value">[N]</div>
                <div class="metric-label">API Endpoints</div>
            </div>
            <div class="metric-card">
                <div class="metric-value">[N]</div>
                <div class="metric-label">Dependencies</div>
            </div>
            <div class="metric-card">
                <div class="metric-value">[N]%</div>
                <div class="metric-label">Test Coverage</div>
            </div>
        </div>
    </section>
    
    <!-- SYSTEM OVERVIEW -->
    <section id="overview">
        <h2>System Overview</h2>
        <!-- Architecture diagram -->
        <div class="diagram-container">
            <!-- Main architecture SVG -->
            <div class="diagram-caption">Figure 1: System Architecture</div>
        </div>
    </section>
    
    <!-- OSI MODEL ANALYSIS -->
    <section id="osi-analysis">
        <h2>OSI Model Analysis</h2>
        <div class="osi-analysis">
            <p>This section maps all system components to their respective OSI layers, showing how data flows through the network stack.</p>
            
            <div class="diagram-container">
                <!-- OSI Layer Mapping SVG -->
                <div class="diagram-caption">Figure 2: Component Mapping to OSI Layers</div>
            </div>
            
            <!-- Per-layer breakdown -->
            <div class="osi-layer-detail">
                <h4>Layer 7 - Application</h4>
                <p><strong>Components:</strong> [List components]</p>
                <p><strong>Operations:</strong> [What happens at this layer]</p>
                <p><strong>Protocols:</strong> HTTP/HTTPS, WebSocket, GraphQL</p>
            </div>
            
            <!-- Repeat for each layer with components -->
        </div>
    </section>
    
    <!-- ANALYTICAL CHARTS -->
    <section id="analytics">
        <h2>System Analytics</h2>
        <div class="charts-grid">
            <div class="chart-card">
                <h4>Component Distribution</h4>
                <!-- Pie chart SVG -->
            </div>
            <div class="chart-card">
                <h4>Components by OSI Layer</h4>
                <!-- Bar chart SVG -->
            </div>
            <div class="chart-card">
                <h4>Dependency Complexity</h4>
                <!-- Line graph SVG -->
            </div>
            <div class="chart-card">
                <h4>Code Distribution</h4>
                <!-- Pie chart SVG -->
            </div>
        </div>
    </section>
    
    <!-- DATA FLOW -->
    <section id="data-flow">
        <h2>Data Flow</h2>
        <div class="diagram-container">
            <!-- Data flow SVG -->
            <div class="diagram-caption">Figure 3: Data Flow Diagram</div>
        </div>
    </section>
    
    <!-- COMPONENT DEEP-DIVE -->
    <section id="components">
        <h2>Component Breakdown</h2>
        <!-- Detailed component analysis -->
    </section>
    
    <!-- REAL-WORLD EXAMPLE -->
    <section id="walkthrough">
        <h2>Real-World Example</h2>
        <!-- Step-by-step walkthrough -->
    </section>
    
    <!-- IMPROVEMENTS -->
    <section id="improvements">
        <h2>Improvement Recommendations</h2>
        <!-- Prioritized improvements -->
    </section>
    
    <!-- GLOSSARY -->
    <section id="glossary">
        <h2>Glossary</h2>
        <!-- Term definitions -->
    </section>
    
    <footer class="footer">
        Generated by /tk:workflow | [PROJECT_NAME] v[VERSION]
    </footer>
</body>
</html>
```

#### File 2: `workflow-executive.html` (Executive Summary)

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Executive Summary: [PROJECT_NAME]</title>
    <style>
        /* Same :root variables and base styles */
        :root {
            --primary: #2563eb;
            --secondary: #64748b;
            --bg: #ffffff;
            --bg-alt: #f8fafc;
            --text: #1e293b;
            --border: #e2e8f0;
            --success: #22c55e;
        }
        
        * { box-sizing: border-box; margin: 0; padding: 0; }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            line-height: 1.8;
            color: var(--text);
            background: var(--bg);
            max-width: 900px;
            margin: 0 auto;
            padding: 2rem;
        }
        
        /* Top nav - same as full */
        .top-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 1.5rem;
            background: var(--bg-alt);
            border: 1px solid var(--border);
            border-radius: 8px;
            margin-bottom: 2rem;
        }
        
        .view-toggle {
            display: flex;
            gap: 0.5rem;
        }
        
        .view-toggle a {
            padding: 0.5rem 1rem;
            border-radius: 6px;
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 500;
        }
        
        .view-toggle a.active {
            background: var(--primary);
            color: white;
        }
        
        .view-toggle a:not(.active) {
            background: white;
            color: var(--text);
            border: 1px solid var(--border);
        }
        
        .btn-pdf {
            background: var(--success);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            font-weight: 500;
            border: none;
            cursor: pointer;
        }
        
        /* Executive-specific styles */
        .exec-header {
            text-align: center;
            padding: 3rem 0;
            border-bottom: 3px solid var(--primary);
            margin-bottom: 3rem;
        }
        
        .exec-header h1 {
            font-size: 2.2rem;
            margin-bottom: 0.5rem;
        }
        
        .exec-header .subtitle {
            color: var(--secondary);
            font-size: 1.1rem;
        }
        
        .exec-summary {
            background: linear-gradient(135deg, #eff6ff 0%, #f0fdf4 100%);
            border-radius: 12px;
            padding: 2rem;
            margin-bottom: 3rem;
            font-size: 1.1rem;
        }
        
        .exec-summary h2 {
            font-size: 1.3rem;
            margin-bottom: 1rem;
            color: var(--primary);
        }
        
        .key-points {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1.5rem;
            margin: 2rem 0;
        }
        
        .key-point {
            background: white;
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 1.5rem;
        }
        
        .key-point h3 {
            font-size: 1rem;
            color: var(--primary);
            margin-bottom: 0.5rem;
        }
        
        .exec-diagram {
            background: var(--bg-alt);
            border-radius: 8px;
            padding: 2rem;
            margin: 2rem 0;
            text-align: center;
        }
        
        .exec-metrics {
            display: flex;
            justify-content: space-around;
            padding: 2rem;
            background: var(--bg-alt);
            border-radius: 8px;
            margin: 2rem 0;
        }
        
        .exec-metric {
            text-align: center;
        }
        
        .exec-metric-value {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--primary);
        }
        
        .exec-metric-label {
            font-size: 0.9rem;
            color: var(--secondary);
        }
        
        .recommendations {
            margin: 2rem 0;
        }
        
        .recommendations h2 {
            font-size: 1.5rem;
            margin-bottom: 1rem;
        }
        
        .rec-item {
            display: flex;
            gap: 1rem;
            padding: 1rem;
            border-bottom: 1px solid var(--border);
        }
        
        .rec-priority {
            font-size: 0.75rem;
            font-weight: 600;
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            height: fit-content;
        }
        
        .priority-high { background: #fecaca; color: #991b1b; }
        .priority-medium { background: #fef08a; color: #854d0e; }
        
        @media print {
            .top-nav { display: none; }
            body { max-width: none; padding: 1cm; }
        }
    </style>
</head>
<body>
    <!-- TOP NAVIGATION -->
    <nav class="top-nav">
        <div class="view-toggle">
            <a href="workflow-full.html">Full Analysis</a>
            <a href="workflow-executive.html" class="active">Executive Summary</a>
        </div>
        <button class="btn-pdf" onclick="window.print()">Export to PDF</button>
    </nav>

    <!-- EXECUTIVE HEADER -->
    <header class="exec-header">
        <h1>[PROJECT_NAME]</h1>
        <div class="subtitle">Executive Workflow Summary</div>
        <div class="meta" style="margin-top: 1rem; color: var(--secondary); font-size: 0.9rem;">
            Generated: [DATE] | Version: [VERSION]
        </div>
    </header>
    
    <!-- EXECUTIVE SUMMARY -->
    <div class="exec-summary">
        <h2>Summary</h2>
        <p>[2-3 paragraph executive summary - what the system does, who uses it, current state, key concerns]</p>
    </div>
    
    <!-- KEY METRICS -->
    <div class="exec-metrics">
        <div class="exec-metric">
            <div class="exec-metric-value">[N]</div>
            <div class="exec-metric-label">Components</div>
        </div>
        <div class="exec-metric">
            <div class="exec-metric-value">[N]</div>
            <div class="exec-metric-label">Endpoints</div>
        </div>
        <div class="exec-metric">
            <div class="exec-metric-value">[N]%</div>
            <div class="exec-metric-label">Coverage</div>
        </div>
        <div class="exec-metric">
            <div class="exec-metric-value">[N]</div>
            <div class="exec-metric-label">Issues</div>
        </div>
    </div>
    
    <!-- SIMPLIFIED ARCHITECTURE DIAGRAM -->
    <div class="exec-diagram">
        <h3 style="margin-bottom: 1rem;">System Architecture</h3>
        <!-- Simplified SVG diagram - high-level only -->
        <div class="diagram-caption">High-level system architecture</div>
    </div>
    
    <!-- KEY POINTS -->
    <div class="key-points">
        <div class="key-point">
            <h3>How It Works</h3>
            <p>[Brief explanation of core functionality]</p>
        </div>
        <div class="key-point">
            <h3>Key Technologies</h3>
            <p>[Primary tech stack]</p>
        </div>
        <div class="key-point">
            <h3>Current State</h3>
            <p>[Health assessment]</p>
        </div>
        <div class="key-point">
            <h3>Risk Areas</h3>
            <p>[Key concerns]</p>
        </div>
    </div>
    
    <!-- TOP RECOMMENDATIONS -->
    <div class="recommendations">
        <h2>Top Recommendations</h2>
        <div class="rec-item">
            <span class="rec-priority priority-high">HIGH</span>
            <div>
                <strong>[Recommendation Title]</strong>
                <p>[Brief description and business impact]</p>
            </div>
        </div>
        <div class="rec-item">
            <span class="rec-priority priority-high">HIGH</span>
            <div>
                <strong>[Recommendation Title]</strong>
                <p>[Brief description and business impact]</p>
            </div>
        </div>
        <div class="rec-item">
            <span class="rec-priority priority-medium">MEDIUM</span>
            <div>
                <strong>[Recommendation Title]</strong>
                <p>[Brief description and business impact]</p>
            </div>
        </div>
    </div>
    
    <footer style="text-align: center; padding: 2rem; color: var(--secondary); font-size: 0.9rem;">
        <a href="workflow-full.html" style="color: var(--primary);">View Full Analysis</a>
        <br><br>
        Generated by /tk:workflow | [PROJECT_NAME] v[VERSION]
    </footer>
</body>
</html>
```

---

### 6. SVG Generation Rules

**CRITICAL: Follow these rules for ALL SVG graphics**

1. **Always close paths** - Every `<path>` element must end with `Z` in the `d` attribute when creating shapes
2. **Use explicit fills** - Set `fill="none"` on path elements that are meant to be lines/strokes only
3. **Prefer simple shapes** - Use `<rect>`, `<circle>`, `<ellipse>`, `<polygon>` over complex `<path>` elements when possible
4. **Validate before output** - After generating any SVG, verify:
   - No overlapping fill areas create unintended shapes
   - All connectors/arrows use `stroke` only, not `fill`
   - Background elements don't extend beyond their intended bounds
   - No black polygon artifacts from unclosed or malformed paths
5. **For charts specifically:**
   - Line graphs: `fill="none"` on the data path, use circles for data points
   - Pie charts: Each slice is a closed path ending with `Z`
   - Bar charts: Use `<rect>` elements with explicit fills
   - All text must have explicit `fill` color
6. **Color Palette:**
   - Primary: `#3b82f6` (blue)
   - Success: `#22c55e` (green)
   - Warning: `#f59e0b` (amber)
   - Error: `#ef4444` (red)
   - Purple: `#8b5cf6`
   - Secondary: `#64748b` (slate)
   - Background: `#f8fafc`
   - Border: `#e2e8f0`

---

### 7. Completion

```bash
# Output files based on mode
if [ "$MODE" = "light" ]; then
    OUTFILE="workflow-overview.html"
else
    OUTFILE_FULL="workflow-full.html"
    OUTFILE_EXEC="workflow-executive.html"
fi

# Place in docs/ if it exists, otherwise project root
if [ -d "docs" ]; then
    [ -n "$OUTFILE" ] && mv "$OUTFILE" "docs/$OUTFILE"
    [ -n "$OUTFILE_FULL" ] && mv "$OUTFILE_FULL" "docs/$OUTFILE_FULL"
    [ -n "$OUTFILE_EXEC" ] && mv "$OUTFILE_EXEC" "docs/$OUTFILE_EXEC"
fi

echo "Generated workflow documentation"

# Git commit
git add docs/workflow*.html 2>/dev/null || git add workflow*.html
git commit -m "docs: generate workflow documentation"
```

**Report:**
- Generated files (list all)
- Sections included
- Charts generated
- OSI layers mapped
- Key metrics captured
- Recommendations count
