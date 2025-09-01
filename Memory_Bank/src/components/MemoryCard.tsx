import { Link } from 'react-router-dom'
import { format } from 'date-fns'
import { 
  Heart, 
  Clock, 
  Tag, 
  MapPin, 
  Calendar,
  MoreVertical,
  Edit,
  Trash2
} from 'lucide-react'
import { useState } from 'react'
import { Memory, useMemory } from '../contexts/MemoryContext'

interface MemoryCardProps {
  memory: Memory
  showActions?: boolean
}

const MemoryCard: React.FC<MemoryCardProps> = ({ memory, showActions = true }) => {
  const { toggleFavorite, deleteMemory } = useMemory()
  const [showMenu, setShowMenu] = useState(false)

  const getCategoryIcon = (category: string) => {
    switch (category) {
      case 'Travel':
        return <MapPin className="w-4 h-4" />
      case 'Family':
        return <Calendar className="w-4 h-4" />
      case 'Books':
        return <Tag className="w-4 h-4" />
      case 'Photos':
        return <Calendar className="w-4 h-4" />
      case 'Music':
        return <Tag className="w-4 h-4" />
      default:
        return <Tag className="w-4 h-4" />
    }
  }

  const getCategoryColor = (category: string) => {
    switch (category) {
      case 'Travel':
        return 'text-green-500 bg-green-50'
      case 'Family':
        return 'text-pink-500 bg-pink-50'
      case 'Books':
        return 'text-purple-500 bg-purple-50'
      case 'Photos':
        return 'text-orange-500 bg-orange-50'
      case 'Music':
        return 'text-red-500 bg-red-50'
      default:
        return 'text-blue-500 bg-blue-50'
    }
  }

  const handleDelete = () => {
    if (window.confirm('Are you sure you want to delete this memory?')) {
      deleteMemory(memory.id)
    }
    setShowMenu(false)
  }

  return (
    <div className="memory-card p-6 relative group">
      {/* Actions Menu */}
      {showActions && (
        <div className="absolute top-4 right-4">
          <div className="relative">
            <button
              onClick={() => setShowMenu(!showMenu)}
              className="p-2 rounded-lg hover:bg-white/50 transition-colors opacity-0 group-hover:opacity-100"
            >
              <MoreVertical className="w-4 h-4 text-gray-500" />
            </button>
            
            {showMenu && (
              <div className="absolute right-0 top-full mt-2 w-48 bg-white rounded-lg shadow-lg border border-white/20 z-10">
                <div className="py-1">
                  <Link
                    to={`/memory/${memory.id}`}
                    className="flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-50"
                    onClick={() => setShowMenu(false)}
                  >
                    <Edit className="w-4 h-4 mr-3" />
                    View Details
                  </Link>
                  <button
                    onClick={handleDelete}
                    className="flex items-center w-full px-4 py-2 text-sm text-red-600 hover:bg-red-50"
                  >
                    <Trash2 className="w-4 h-4 mr-3" />
                    Delete
                  </button>
                </div>
              </div>
            )}
          </div>
        </div>
      )}

      {/* Header */}
      <div className="flex items-start justify-between mb-4">
        <div className="flex-1">
          <Link to={`/memory/${memory.id}`}>
            <h3 className="text-lg font-semibold text-gray-900 hover:text-primary-600 transition-colors line-clamp-2">
              {memory.title}
            </h3>
          </Link>
          <div className="flex items-center mt-2 space-x-2">
            <span className={`inline-flex items-center px-2 py-1 rounded-full text-xs font-medium ${getCategoryColor(memory.category)}`}>
              {getCategoryIcon(memory.category)}
              <span className="ml-1">{memory.category}</span>
            </span>
            {memory.isFavorite && (
              <Heart className="w-4 h-4 text-pink-500 fill-current" />
            )}
          </div>
        </div>
      </div>

      {/* Content */}
      <div className="mb-4">
        <p className="text-gray-600 line-clamp-3 leading-relaxed">
          {memory.content}
        </p>
      </div>

      {/* Tags */}
      {memory.tags.length > 0 && (
        <div className="mb-4">
          <div className="flex flex-wrap gap-1">
            {memory.tags.slice(0, 3).map((tag, index) => (
              <span
                key={index}
                className="inline-flex items-center px-2 py-1 rounded-md text-xs font-medium bg-gray-100 text-gray-700"
              >
                #{tag}
              </span>
            ))}
            {memory.tags.length > 3 && (
              <span className="inline-flex items-center px-2 py-1 rounded-md text-xs font-medium bg-gray-100 text-gray-500">
                +{memory.tags.length - 3} more
              </span>
            )}
          </div>
        </div>
      )}

      {/* Footer */}
      <div className="flex items-center justify-between pt-4 border-t border-gray-100">
        <div className="flex items-center text-sm text-gray-500">
          <Clock className="w-4 h-4 mr-1" />
          {format(memory.createdAt, 'MMM d, yyyy')}
        </div>
        
        {showActions && (
          <button
            onClick={() => toggleFavorite(memory.id)}
            className={`p-2 rounded-lg transition-colors ${
              memory.isFavorite
                ? 'text-pink-500 hover:text-pink-600'
                : 'text-gray-400 hover:text-pink-500'
            }`}
          >
            <Heart className={`w-4 h-4 ${memory.isFavorite ? 'fill-current' : ''}`} />
          </button>
        )}
      </div>

      {/* Additional Info */}
      {(memory.location || memory.weather || memory.mood) && (
        <div className="mt-3 pt-3 border-t border-gray-100">
          <div className="flex items-center space-x-4 text-xs text-gray-500">
            {memory.location && (
              <div className="flex items-center">
                <MapPin className="w-3 h-3 mr-1" />
                {memory.location}
              </div>
            )}
            {memory.weather && (
              <div className="flex items-center">
                <span>☀️ {memory.weather}</span>
              </div>
            )}
            {memory.mood && (
              <div className="flex items-center">
                <span>😊 {memory.mood}</span>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  )
}

export default MemoryCard
