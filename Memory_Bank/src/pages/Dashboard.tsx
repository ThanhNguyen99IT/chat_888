import { useState } from 'react'
import { Link } from 'react-router-dom'
import { format } from 'date-fns'
import { 
  Plus, 
  Heart, 
  Clock, 
  Tag, 
  Calendar,
  TrendingUp,
  BookOpen,
  MapPin,
  Users,
  Camera,
  Music,
  Brain
} from 'lucide-react'
import { useMemory } from '../contexts/MemoryContext'
import MemoryCard from '../components/MemoryCard'

const Dashboard = () => {
  const { state, getFavoriteMemories, getMemoriesByCategory } = useMemory()
  const [selectedCategory, setSelectedCategory] = useState<string>('all')

  const categories = [
    { name: 'all', label: 'All Memories', icon: Brain, color: 'text-gray-600' },
    { name: 'Personal', label: 'Personal', icon: Brain, color: 'text-blue-500' },
    { name: 'Travel', label: 'Travel', icon: MapPin, color: 'text-green-500' },
    { name: 'Family', label: 'Family', icon: Users, color: 'text-pink-500' },
    { name: 'Books', label: 'Books', icon: BookOpen, color: 'text-purple-500' },
    { name: 'Photos', label: 'Photos', icon: Camera, color: 'text-orange-500' },
    { name: 'Music', label: 'Music', icon: Music, color: 'text-red-500' },
  ]

  const favoriteMemories = getFavoriteMemories()
  const recentMemories = state.memories.slice(0, 6)
  const filteredMemories = selectedCategory === 'all' 
    ? state.memories 
    : getMemoriesByCategory(selectedCategory)

  const stats = [
    {
      title: 'Total Memories',
      value: state.memories.length,
      icon: BookOpen,
      color: 'text-blue-500',
      bgColor: 'bg-blue-50'
    },
    {
      title: 'Favorites',
      value: favoriteMemories.length,
      icon: Heart,
      color: 'text-pink-500',
      bgColor: 'bg-pink-50'
    },
    {
      title: 'This Month',
      value: state.memories.filter(m => {
        const monthAgo = new Date()
        monthAgo.setMonth(monthAgo.getMonth() - 1)
        return m.createdAt > monthAgo
      }).length,
      icon: TrendingUp,
      color: 'text-green-500',
      bgColor: 'bg-green-50'
    },
    {
      title: 'Categories',
      value: new Set(state.memories.map(m => m.category)).size,
      icon: Tag,
      color: 'text-purple-500',
      bgColor: 'bg-purple-50'
    }
  ]

  return (
    <div className="space-y-8 animate-fade-in">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900 mb-2">
            Welcome back to your Memory Bank
          </h1>
          <p className="text-gray-600">
            You have {state.memories.length} precious memories stored
          </p>
        </div>
        <Link
          to="/create"
          className="btn-primary mt-4 sm:mt-0 inline-flex items-center"
        >
          <Plus className="w-5 h-5 mr-2" />
          Add Memory
        </Link>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
        {stats.map((stat) => (
          <div key={stat.title} className="memory-card p-6">
            <div className="flex items-center">
              <div className={`p-3 rounded-lg ${stat.bgColor}`}>
                <stat.icon className={`w-6 h-6 ${stat.color}`} />
              </div>
              <div className="ml-4">
                <p className="text-sm font-medium text-gray-600">{stat.title}</p>
                <p className="text-2xl font-bold text-gray-900">{stat.value}</p>
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* Category Filter */}
      <div className="memory-card p-6">
        <h2 className="text-xl font-semibold text-gray-900 mb-4">Filter by Category</h2>
        <div className="flex flex-wrap gap-3">
          {categories.map((category) => (
            <button
              key={category.name}
              onClick={() => setSelectedCategory(category.name)}
              className={`
                flex items-center px-4 py-2 rounded-lg text-sm font-medium transition-all duration-200
                ${selectedCategory === category.name
                  ? 'bg-gradient-to-r from-primary-500 to-memory-500 text-white shadow-lg'
                  : 'bg-white/50 text-gray-700 hover:bg-white hover:text-gray-900 border border-white/20'
                }
              `}
            >
              <category.icon className={`w-4 h-4 mr-2 ${selectedCategory === category.name ? 'text-white' : category.color}`} />
              {category.label}
            </button>
          ))}
        </div>
      </div>

      {/* Recent Memories */}
      {recentMemories.length > 0 && (
        <div>
          <div className="flex items-center justify-between mb-6">
            <h2 className="text-xl font-semibold text-gray-900">Recent Memories</h2>
            <Link to="/" className="text-primary-600 hover:text-primary-700 font-medium">
              View all
            </Link>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {recentMemories.map((memory) => (
              <MemoryCard key={memory.id} memory={memory} />
            ))}
          </div>
        </div>
      )}

      {/* All Memories */}
      <div>
        <div className="flex items-center justify-between mb-6">
          <h2 className="text-xl font-semibold text-gray-900">
            {selectedCategory === 'all' ? 'All Memories' : `${selectedCategory} Memories`}
          </h2>
          <div className="text-sm text-gray-500">
            {filteredMemories.length} memory{filteredMemories.length !== 1 ? 'ies' : 'y'}
          </div>
        </div>
        
        {filteredMemories.length === 0 ? (
          <div className="memory-card p-12 text-center">
            <BookOpen className="w-16 h-16 text-gray-300 mx-auto mb-4" />
            <h3 className="text-lg font-medium text-gray-900 mb-2">
              {selectedCategory === 'all' ? 'No memories yet' : `No ${selectedCategory} memories`}
            </h3>
            <p className="text-gray-600 mb-6">
              {selectedCategory === 'all' 
                ? 'Start building your memory bank by adding your first memory'
                : `Add your first ${selectedCategory.toLowerCase()} memory`
              }
            </p>
            <Link to="/create" className="btn-primary">
              <Plus className="w-5 h-5 mr-2" />
              Add Memory
            </Link>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {filteredMemories.map((memory) => (
              <MemoryCard key={memory.id} memory={memory} />
            ))}
          </div>
        )}
      </div>
    </div>
  )
}

export default Dashboard
