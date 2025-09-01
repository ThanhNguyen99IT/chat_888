# Memory Bank 🧠💭

A beautiful and intuitive web application for storing, organizing, and cherishing your precious memories. Built with React, TypeScript, and Tailwind CSS.

## ✨ Features

- **📝 Create Memories**: Add detailed memories with titles, content, categories, and tags
- **🏷️ Organize**: Categorize memories (Personal, Travel, Family, Books, Photos, Music)
- **🔍 Search & Filter**: Find memories by keywords, tags, or categories
- **⭐ Favorites**: Mark special memories as favorites
- **📱 Responsive**: Beautiful design that works on all devices
- **💾 Local Storage**: Your memories are saved locally in your browser
- **🎨 Modern UI**: Clean, modern interface with smooth animations
- **📊 Statistics**: View memory statistics and insights

## 🚀 Getting Started

### Prerequisites

- Node.js (version 16 or higher)
- npm or yarn

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd memory-bank
```

2. Install dependencies:
```bash
npm install
```

3. Start the development server:
```bash
npm run dev
```

4. Open your browser and navigate to `http://localhost:3000`

## 🛠️ Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run preview` - Preview production build
- `npm run lint` - Run ESLint
- `npm run lint:fix` - Fix ESLint errors

## 📁 Project Structure

```
src/
├── components/          # Reusable UI components
│   ├── Layout.tsx      # Main layout with sidebar
│   └── MemoryCard.tsx  # Memory card component
├── contexts/           # React contexts
│   └── MemoryContext.tsx # Memory state management
├── pages/              # Page components
│   ├── Dashboard.tsx   # Main dashboard
│   ├── CreateMemory.tsx # Create new memory
│   ├── MemoryDetail.tsx # View/edit memory
│   └── Search.tsx      # Search memories
├── App.tsx             # Main app component
├── main.tsx           # App entry point
└── index.css          # Global styles
```

## 🎯 Key Features Explained

### Memory Management
- **Create**: Add new memories with rich details including mood, weather, and location
- **Edit**: Modify existing memories with inline editing
- **Delete**: Remove memories with confirmation
- **Favorite**: Mark important memories for quick access

### Organization
- **Categories**: Organize memories into predefined categories
- **Tags**: Add custom tags for better organization
- **Search**: Find memories by title, content, tags, or category
- **Filter**: Filter memories by category

### User Experience
- **Responsive Design**: Works seamlessly on desktop, tablet, and mobile
- **Smooth Animations**: Beautiful transitions and hover effects
- **Intuitive Navigation**: Easy-to-use sidebar navigation
- **Local Storage**: Data persists between sessions

## 🎨 Design System

The application uses a custom design system built with Tailwind CSS:

- **Colors**: Primary blue and memory purple gradients
- **Typography**: Inter font family for clean readability
- **Components**: Consistent card-based layout with glassmorphism effects
- **Animations**: Smooth transitions and micro-interactions

## 🔧 Technology Stack

- **Frontend**: React 18 with TypeScript
- **Styling**: Tailwind CSS with custom components
- **Icons**: Lucide React
- **Date Handling**: date-fns
- **Build Tool**: Vite
- **State Management**: React Context API
- **Routing**: React Router DOM

## 📱 Browser Support

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [React](https://reactjs.org/) - A JavaScript library for building user interfaces
- [Tailwind CSS](https://tailwindcss.com/) - A utility-first CSS framework
- [Lucide](https://lucide.dev/) - Beautiful & consistent icon toolkit
- [Vite](https://vitejs.dev/) - Next Generation Frontend Tooling

## 📞 Support

If you have any questions or need help, please open an issue on GitHub.

---

Made with ❤️ for preserving precious memories
