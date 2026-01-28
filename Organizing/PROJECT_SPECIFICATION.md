# Missive - Project Specification

## 1. Product Vision

### 1.1 Core Vision Statement
**FOR** fantasy LARPers and people seeking whimsy in digital communication  
**WHO** want to communicate in character or add intentionality to their messages  
**Missive** is a mobile messaging app  
**THAT** is designed to feel like interfacing with a magical device  
**UNLIKE** Discord and other modern messaging apps  
**OUR PRODUCT** does not break immersion with a modern appearance and reintroduces intentionality and whimsy to digital communication

### 1.2 Design Philosophy
- **No tooltips**: The UI should be completely incomprehensible unless someone explains it, making it feel like learning magic
- **Immersive design**: The app doesn't show an icon of a crystal ball—it makes your phone BECOME the crystal ball
- **Restriction breeds creativity**: Intentional limitations (like time delays) make each message feel special and significant
- **Letter-like communication**: Messages should feel like a series of letters, not instant texts

### 1.3 Target Audience
- Fantasy LARPers who want immersive in-character communication
- People seeking more whimsical and intentional digital communication
- Couples and friends who want to make messages feel special
- Tabletop RPG players (DMs and players) for secret messages and in-character communication

## 2. Core Features

### 2.1 Authentication & User Setup
- **Google Authentication**: Simple login using Google accounts
- **User Profile Creation**:
  - Fantasy name (first and last name, optional title)
  - Profile picture (pfp)
  - Unique 6-rune sequence (automatically generated)
- **Settings Screen** (accessed via own rune):
  - Log out
  - Change name
  - Change profile picture
  - Option to turn off sound effects
  - (Optional) Switch character option (separate name, pfp, message history, contacts)

### 2.2 Rune System
- **Rune Structure**:
  - Each user has a unique sequence of 6 runes
  - Runes are mapped to letters (A-Z, 26 possible runes)
  - Runes are displayed in a circular pattern: 2 concentric circles with 6 runes evenly spaced in the ring between them
  - Runes are oriented radially (sideways on sides, upside down on bottom)
  - First letter represents uppermost rune, continuing clockwise
- **Rune Display**:
  - Inner circle shows user's profile picture
  - Outer ring displays the 6 runes
  - "You" label below personal rune

### 2.3 Home Screen
- **Layout**:
  - Personal rune circle and pfp at bottom (clickable to access Settings)
  - "Construct New Portal" empty rune (centered in standard zoom)
    - Same size as user runes
    - No filled runes, pfp is a swirl
    - Labeled "Construct New Portal" above
  - Previously connected runes float around the screen
    - Display user's pfp inside and name above
    - Can scroll and zoom to see all contacts
    - More message history = closer to center (optional)
- **Interactions**:
  - Unread messages: Contact's rune glows
  - Select contacts: Click on rune to create a line from your rune to theirs
  - Group chat: Select multiple runes
  - Open messaging: Shake phone (or press and hold) to "open portal" between selected people
  - Access past group chats: Press and hold on pfp to make last connection light up, swipe backwards to see previous

### 2.4 Construct New Portal Screen (Adding Contacts)
- **Rune Entry Methods** (to be decided):
  - **Option A**: Greyed out circles where runes go. Click circle to open rune creator screen
  - **Option B**: Write runes sequentially at top, they populate the rune circle
  - **Option C**: Entire rune circle has greyed out possible lines, user zooms in to select
- **Rune Creation**:
  - Greyed out or dotted lines representing rune segments
  - Select/draw lines to make them black
  - System validates individual runes when switching to next rune
  - Once all 6 spots have valid runes, system checks for user matches in database
- **Connection Establishment**:
  - When valid rune circle is entered, matching user's pfp appears
  - Shake phone (or press and hold) to "cast spell" and establish connection
  - Pfp glows and then appears on home screen

### 2.5 Craft a Message Screen
- **Drawing Tools**:
  - Draw messages with glowy lines
  - (If time permits) Color selection, brush size, eraser
  - Tap with 2 fingers to undo
- **Voice Messages**:
  - Press and hold button to record "Whispers"
  - Shows magical waveform when recording
  - Shows talking mouth icon when received
- **Sending**:
  - Shake phone (or press and hold) to send
  - Swipe left to see message history

### 2.6 Message History Screen
- **Navigation**:
  - Swipe backwards to see old messages (one per screen)
  - Swipe forwards to return to newer messages
  - If new messages arrive while reading old ones, they appear on the far right
  - Faint glow appears on that side until read
  - Swipe past newest message to return to "Craft a message screen"
- **Message Display**:
  - Sender's rune circle surrounding their message
  - Sender's name below message
  - Glowing unread messages fade when viewed

### 2.7 Message Features
- **Message Types**:
  - Drawings (digital touch style)
  - Voice messages ("Whispers")
  - (Optional) Time delays: Messages take minutes to hours to arrive (like sending a letter in real life)
- **Message Opening**:
  - When you open a message, it takes up the whole screen
  - Swirly spell animation when opening

### 2.8 Chat Room Management
- **Deletion**:
  - Dramatically scribble away connecting lines to delete
  - Shake (or press and hold on your rune) to confirm deletion

### 2.9 Audio & Visual Effects
- **Sound Effects**: Throughout the app for various interactions
- **Animations**:
  - Swirly or fading animations when transitioning between screens
  - Spell casting animations when sending messages
  - Glowing effects for unread messages

## 3. Technical Requirements

### 3.1 Frontend Requirements
- **User Interface**:
  - User authentication (registration via Google, login, logout)
  - User profile management (name, pfp)
  - Chat room creation and navigation
  - Display conversation history
  - List all available chat rooms (home screen with floating runes)
  - Enable users to delete chat rooms
- **Functionality**:
  - Send and receive messages in real-time through backend
  - Smooth navigation between different screens
  - Display error messages for authentication or connection issues
  - Seamless integration with backend for real-time messaging, authentication, and database updates

### 3.2 Backend Requirements
- **Server Functionality**:
  - Handle user authentication (registration, login, logout)
  - Store and update users' first and last names in database
  - Enable creation and deletion of chat rooms
  - Maintain database for:
    - User credentials
    - Messaging history
    - List of created chat rooms and their participants
  - Enable real-time messaging functionality between connected clients
- **Database Management**:
  - Store and retrieve data efficiently for all features
  - Handle error cases (invalid user actions, database failures)
  - Provide robust APIs for frontend communication

### 3.3 User Identification
- **Rune System**:
  - Each user has unique 6-rune sequence (stored as 6-letter code)
  - Runes are used for public identification and connection
- **User ID**:
  - Google authentication provides unique user ID
  - Can hash Gmail or use Google's user ID system

## 4. User Personas & Use Cases

### 4.1 Stelio Kontos (Community Manager)
- **Profile**: 28-year-old board game manager, LARPer, community organizer
- **Use Case**: 
  - Send quick, context-sensitive notes to employees and community members
  - Send secret messages to players while dungeon mastering
  - Enhance tabletop game immersion
- **Key Features**: Drawing tools, secret messaging, immersive UI

### 4.2 Newt McFadden (High School LARPer)
- **Profile**: 18-year-old high school senior, theater enthusiast, LARPer
- **Use Case**:
  - Send intentional "letters" to long-distance romantic partner
  - Use during LARP events for immersive espionage/scouting roleplay
  - Make communication feel special and significant
- **Key Features**: Time delays, drawing tools, fully immersive UI

### 4.3 Jessica Molasses (Parent & LARPer)
- **Profile**: 41-year-old engineer, active parent, LARP/Ren Faire enthusiast
- **Use Case**:
  - Roleplay as wizard during LARP events
  - Communicate cutely with kids using themed messages
- **Key Features**: Immersive UI, drawing tools, voice messages

## 5. Design Constraints & Decisions

### 5.1 UI/UX Decisions
- **No QWERTY keyboard**: Messages are created through drawing and voice only
- **No tooltips**: UI should be learned through exploration or explanation
- **Gesture-based interactions**: Shake phone, swipe, press and hold
- **Full-screen message viewing**: Messages take up entire screen when opened

### 5.2 Technical Constraints
- **Mobile-first**: Designed for mobile devices
- **Real-time messaging**: Requires WebSocket or similar real-time communication
- **Database**: Must store users, messages, chat rooms, and rune sequences
- **Authentication**: Google OAuth integration

### 5.3 Feature Scope Limitations
- **No multiple accounts per device** (initially considered but rejected to avoid complexity)
- **Time delays optional**: May be implemented if time permits
- **Advanced drawing tools optional**: Basic drawing required, advanced features if time permits
- **Character switching optional**: May be added if time permits

## 6. Implementation Priorities

### 6.1 Core Features (Must Have)
1. Google authentication
2. User profile creation (name, pfp, rune generation)
3. Home screen with floating rune contacts
4. Construct New Portal (add contacts via rune entry)
5. Craft Message screen (drawing and voice messages)
6. Message History screen (swipeable messages)
7. Real-time messaging between users
8. Basic sound effects and animations

### 6.2 Important Features (Should Have)
1. Unread message indicators (glowing runes)
2. Group chat functionality
3. Chat room deletion
4. Settings screen
5. Smooth transitions and animations

### 6.3 Nice to Have (If Time Permits)
1. Time delays for messages
2. Advanced drawing tools (color, brush size, eraser)
3. Character switching
4. Dark mode
5. Custom phone case integration considerations

## 7. Success Criteria

The application should:
- Feel like using a magical device, not a modern messaging app
- Maintain immersion for LARPers during events
- Make messages feel special and intentional
- Be functional for real-time communication
- Provide a whimsical alternative to standard messaging apps

---

**Document Version**: 1.0  
**Last Updated**: Based on brainstorming.txt and featuredoc.txt  
**Note**: This specification focuses on the core vision and avoids feature creep by sticking to described features only.

