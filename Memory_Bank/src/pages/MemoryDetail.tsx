import { useState } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { format } from 'date-fns'
import { 
  ArrowLeft, 
  Edit, 
  Trash2, 
  Heart, 
  MapPin, 
  Cloud, 
  Smile,
  Calendar,
  Tag,
  Save,
  X
} from 'lucide-react'
import { useMemory } from '../contexts/MemoryContext'

const MemoryDetail = () => {
  const { id } = useParams<{ id: string }>()
  const navigate = useNavigate()
  const { getMemory, updateMemory, deleteMemory, toggleFavorite } = useMemory()
  const [isEditing, setIsEditing] = useState(false)
  const [isSubmitting, setIsSubmitting] = useState(false)
  
  const memory = id ? getMemory(id) : null

  const [editData, setEditData] = useState({
    title: memory?.title || '',
    content: memory?.content || '',
    category: memory?.category || 'Personal',
    tags: memory?.tags || [],
    location: memory?.location || '',
    weather: memory?.weather || '',
    mood: memory?.mood || '',
  })

  const [newTag, setNewTag] = useState('')

  if (!memory) {
    return (
      <div className="max-w-4xl mx-auto animate-fade-in">
        <div className="memory-card p-12 text-center">
          <h1 className="text-2xl font-bold text-gray-900 mb-4">Memory Not Found</h1>
          <p className="text-gray-600 mb-6">The memory you're looking for doesn't exist.</p>
          <button
            onClick={() => navigate('/')}
            className="btn-primary"
          >
            <ArrowLeft className="w-5 h-5 mr-2" />
            Back to Dashboard
          </button>
        </div>
      </div>
    )
  }

  const categories = [
    'Personal',
    'Travel',
    'Family',
    'Books',
    'Photos',
    'Music'
  ]

  const moods = [
    { value: 'happy', label: '😊 Happy' },
    { value: 'sad', label: '😢 Sad' },
    { value: 'excited', label: '🤩 Excited' },
    { value: 'calm', label: '😌 Calm' },
    { value: 'nostalgic', label: '🥺 Nostalgic' },
    { value: 'inspired', label: '💡 Inspired' },
  ]

  const weatherOptions = [
    '☀️ Sunny',
    '☁️ Cloudy',
    '🌧️ Rainy',
    '❄️ Snowy',
    '🌪️ Windy',
    '🌈 Clear'
  ]

  const handleInputChange = (field: string, value: any) => {
    setEditData(prev => ({
      ...prev,
      [field]: value
    }))
  }

  const handleAddTag = () => {
    if (newTag.trim() && !editData.tags.includes(newTag.trim())) {
      setEditData(prev => ({
        ...prev,
        tags: [...prev.tags, newTag.trim()]
      }))
      setNewTag('')
    }
  }

  const handleRemoveTag = (tagToRemove: string) => {
    setEditData(prev => ({
      ...prev,
      tags: prev.tags.filter(tag => tag !== tagToRemove)
    }))
  }

  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter') {
      e.preventDefault()
      handleAddTag()
    }
  }

  const handleSave = async () => {
    if (!editData.title.trim() || !editData.content.trim()) {
      alert('Please fill in the title and content fields')
      return
    }

    setIsSubmitting(true)
    
    try {
      updateMemory(memory.id, {
        title: editData.title.trim(),
        content: editData.content.trim(),
        category: editData.category,
        tags: editData.tags,
        location: editData.location.trim(),
        weather: editData.weather,
        mood: editData.mood || undefined,
      })
      
      setIsEditing(false)
    } catch (error) {
      console.error('Error updating memory:', error)
      alert('Failed to update memory. Please try again.')
    } finally {
      setIsSubmitting(false)
    }
  }

  const handleDelete = () => {
    if (window.confirm('Are you sure you want to delete this memory? This action cannot be undone.')) {
      deleteMemory(memory.id)
      navigate('/')
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

  return (
    <div className="max-w-4xl mx-auto animate-fade-in">
      {/* Header */}
      <div className="flex items-center justify-between mb-8">
        <div className="flex items-center space-x-4">
          <button
            onClick={() => navigate('/')}
            className="btn-secondary"
          >
            <ArrowLeft className="w-5 h-5 mr-2" />
            Back
          </button>
          <div>
            <h1 className="text-3xl font-bold text-gray-900">
              {isEditing ? 'Edit Memory' : memory.title}
            </h1>
            <p className="text-gray-600">
              {format(memory.createdAt, 'MMMM d, yyyy')}
            </p>
          </div>
        </div>
        
        <div className="flex items-center space-x-2">
          <button
            onClick={() => toggleFavorite(memory.id)}
            className={`p-3 rounded-lg transition-colors ${
              memory.isFavorite
                ? 'text-pink-500 hover:text-pink-600'
                : 'text-gray-400 hover:text-pink-500'
            }`}
          >
            <Heart className={`w-6 h-6 ${memory.isFavorite ? 'fill-current' : ''}`} />
          </button>
          
          {!isEditing ? (
            <>
              <button
                onClick={() => setIsEditing(true)}
                className="btn-secondary"
              >
                <Edit className="w-5 h-5 mr-2" />
                Edit
              </button>
              <button
                onClick={handleDelete}
                className="btn-secondary text-red-600 hover:text-red-700 hover:bg-red-50"
              >
                <Trash2 className="w-5 h-5 mr-2" />
                Delete
              </button>
            </>
          ) : (
            <>
              <button
                onClick={() => setIsEditing(false)}
                className="btn-secondary"
              >
                <X className="w-5 h-5 mr-2" />
                Cancel
              </button>
              <button
                onClick={handleSave}
                disabled={isSubmitting}
                className="btn-primary disabled:opacity-50"
              >
                {isSubmitting ? (
                  <>
                    <div className="animate-spin rounded-full h-5 w-5 border-b-2 border-white mr-2"></div>
                    Saving...
                  </>
                ) : (
                  <>
                    <Save className="w-5 h-5 mr-2" />
                    Save
                  </>
                )}
              </button>
            </>
          )}
        </div>
      </div>

      {/* Memory Content */}
      <div className="memory-card p-8">
        {isEditing ? (
          <div className="space-y-6">
            {/* Title */}
            <div>
              <label htmlFor="title" className="block text-sm font-medium text-gray-700 mb-2">
                Title
              </label>
              <input
                type="text"
                id="title"
                value={editData.title}
                onChange={(e) => handleInputChange('title', e.target.value)}
                className="input-field text-xl"
                required
              />
            </div>

            {/* Content */}
            <div>
              <label htmlFor="content" className="block text-sm font-medium text-gray-700 mb-2">
                Content
              </label>
              <textarea
                id="content"
                value={editData.content}
                onChange={(e) => handleInputChange('content', e.target.value)}
                className="input-field min-h-[300px] resize-none"
                required
              />
            </div>

            {/* Category */}
            <div>
              <label htmlFor="category" className="block text-sm font-medium text-gray-700 mb-2">
                Category
              </label>
              <select
                id="category"
                value={editData.category}
                onChange={(e) => handleInputChange('category', e.target.value)}
                className="input-field"
              >
                {categories.map(category => (
                  <option key={category} value={category}>
                    {category}
                  </option>
                ))}
              </select>
            </div>

            {/* Tags */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Tags
              </label>
              <div className="flex gap-2 mb-3">
                <input
                  type="text"
                  value={newTag}
                  onChange={(e) => setNewTag(e.target.value)}
                  onKeyPress={handleKeyPress}
                  className="input-field flex-1"
                  placeholder="Add a tag..."
                />
                <button
                  type="button"
                  onClick={handleAddTag}
                  className="btn-secondary"
                >
                  <Tag className="w-5 h-5" />
                </button>
              </div>
              {editData.tags.length > 0 && (
                <div className="flex flex-wrap gap-2">
                  {editData.tags.map((tag, index) => (
                    <span
                      key={index}
                      className="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-primary-100 text-primary-800"
                    >
                      #{tag}
                      <button
                        type="button"
                        onClick={() => handleRemoveTag(tag)}
                        className="ml-2 hover:text-primary-600"
                      >
                        <X className="w-4 h-4" />
                      </button>
                    </span>
                  ))}
                </div>
              )}
            </div>
          </div>
        ) : (
          <div className="space-y-6">
            {/* Header Info */}
            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-3">
                <span className={`inline-flex items-center px-3 py-1 rounded-full text-sm font-medium ${getCategoryColor(memory.category)}`}>
                  <Tag className="w-4 h-4 mr-1" />
                  {memory.category}
                </span>
                {memory.isFavorite && (
                  <Heart className="w-5 h-5 text-pink-500 fill-current" />
                )}
              </div>
              <div className="text-sm text-gray-500">
                Last updated: {format(memory.updatedAt, 'MMM d, yyyy')}
              </div>
            </div>

            {/* Content */}
            <div className="prose max-w-none">
              <p className="text-gray-700 leading-relaxed whitespace-pre-wrap">
                {memory.content}
              </p>
            </div>

            {/* Tags */}
            {memory.tags.length > 0 && (
              <div>
                <h3 className="text-sm font-medium text-gray-700 mb-2">Tags</h3>
                <div className="flex flex-wrap gap-2">
                  {memory.tags.map((tag, index) => (
                    <span
                      key={index}
                      className="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-gray-100 text-gray-700"
                    >
                      #{tag}
                    </span>
                  ))}
                </div>
              </div>
            )}

            {/* Additional Details */}
            {(memory.location || memory.weather || memory.mood) && (
              <div className="pt-6 border-t border-gray-200">
                <h3 className="text-sm font-medium text-gray-700 mb-3">Additional Details</h3>
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                  {memory.location && (
                    <div className="flex items-center text-sm text-gray-600">
                      <MapPin className="w-4 h-4 mr-2 text-gray-400" />
                      {memory.location}
                    </div>
                  )}
                  {memory.weather && (
                    <div className="flex items-center text-sm text-gray-600">
                      <Cloud className="w-4 h-4 mr-2 text-gray-400" />
                      {memory.weather}
                    </div>
                  )}
                  {memory.mood && (
                    <div className="flex items-center text-sm text-gray-600">
                      <Smile className="w-4 h-4 mr-2 text-gray-400" />
                      {moods.find(m => m.value === memory.mood)?.label || memory.mood}
                    </div>
                  )}
                </div>
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  )
}

export default MemoryDetail
