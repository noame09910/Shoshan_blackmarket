

### **Project Overview**

**NeonBalckMarket** is a sophisticated UI framework designed for a game economy system, specifically created for the Israeli gaming community by Gamers-Israel. This is a **black market interface** that serves as an interactive menu system for in-game illegal activities and commerce.

### **Core Purpose**

The script creates a stylish, immersive dark-themed user interface that allows players to engage with various black market operations. It acts as a middle-layer between player interactions and backend game servers, facilitating transactions and information queries related to underground economy mechanics.

### **Key Features & Components**

#### **Visual Design**

- **Dark Theme**: Uses a sophisticated black background (`#121212`) with neon green accents (`#00ff95`) for cyberpunk aesthetics
- **Responsive Grid Layout**: Features an auto-fitting grid system that displays multiple market items/services
- **Background Character**: Michael's image is displayed subtly in the background (positioned at 115% vertical, 30% scale)
- **Neon Borders**: 1px neon green borders on all interactive items for that hacker/underground market feel
- **Custom Scrollbar**: Dark-themed scrollbar with hover effects for better UX


#### **Interactive Elements (Grid Items)**

The market offers 8 main categories (Hebrew labeled):

1. **חיסולים (Bounty/Assassinations)** - Contract-based elimination tasks
2. **כלים (Tools)** - Equipment and gadgets for criminal activities
3. **תיקון נשק (Weapon Repair)** - Maintenance services for weaponry
4. **כמה שוטרים בשרת (Police Count)** - Real-time information about law enforcement presence (includes cost tooltip: ₪8,000)
5. **עבודת סמים (Drug Operations)** - Narcotics-related activities
6. **בדיקת לוחית (License Plate Check)** - Vehicle registration lookup
7. **שם זין על השוק (Market Gossip)** - Underground intelligence/rumors
8. **Rampage** - Chaos/destruction contracts


### **Technical Architecture**

#### **Frontend (Client-Side)**

- Built with HTML5, CSS3, and vanilla JavaScript
- Uses jQuery 3.6.0 for AJAX requests and DOM manipulation
- Implements event delegation for click handlers on grid items
- Fade in/out animations using jQuery's fadeIn/fadeOut methods


#### **Interaction Flow**

1. **DOM Ready Event** - Script initializes when page loads
2. **Click Detection** - Each grid item listens for click events
3. **Action Management** - `ManageAction()` function processes which market category was clicked
4. **Backend Communication** - Posts actions to `https://neon-balckmarket/action` endpoint with JSON payload
5. **UI Control** - Window message events trigger show/hide UI, ESC key hides menu and posts close signal


#### **Advanced Features**

- **Tooltip System**: Dynamically creates and positions tooltips (especially for the cops action showing its cost)
- **Keyboard Support**: ESC key immediately closes the UI
- **Window Messaging**: Communicates with parent window via `postMessage` API for show/hide commands
- **Fade Animations**: Smooth jQuery animations for UI visibility transitions


### **Backend Integration**

The script communicates with a backend server (`https://neon-balckmarket/`) via POST requests:

- **`/action` endpoint**: Receives the selected action as JSON and processes market transactions
- **`/close` endpoint**: Notifies the server when the market UI is closed


### **Security & Performance Notes**

- Uses CORS-friendly jQuery POST requests
- Includes efficient event delegation (single listener per grid-item type)
- Implements pointer-events: none on tooltips to prevent interference
- Responsive design handles mobile, tablet, and desktop viewports
