import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { 
  Save, 
  X, 
  Tag, 
  MapPin, 
  Cloud, 
  Smile,
  Plus,
  Trash2
} from 'lucide-react'
import { useMemory } from '../contexts/MemoryContext'

const CreateMemory = () => {
  const navigate = useNavigate()
  const { addMemory } = useMemory()
  const [isSubmitting, setIsSubmitting] = useState(false)
  
  const [formData, setFormData] = useState({
    title: '',
    content: '',
    category: 'Personal',
    tags: [] as string[],
    location: '',
    weather: '',
    mood: '' as 'happy' | 'sad' | 'excited' | 'calm' | 'nostalgic' | 'inspired' | '',
    isFavorite: false
  })

  const [newTag, setNewTag] = useState('')

  const categories = [
    'Personal',
    'Travel',
    'Family',
    'Books',
    'Photos',
    'Music'
  ]

  const moods = [
    { value: 'happy', label: '😊 Happy', color: 'text-yellow-500' },
    { value: 'sad', label: '😢 Sad', color: 'text-blue-500' },
    { value: 'excited', label: '🤩 Excited', color: 'text-orange-500' },
    { value: 'calm', label: '😌 Calm', color: 'text-green-500' },
    { value: 'nostalgic', label: '🥺 Nostalgic', color: 'text-purple-500' },
    { value: 'inspired', label: '💡 Inspired', color: 'text-pink-500' },
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
    setFormData(prev => ({
      ...prev,
      [field]: value
    }))
  }

  const handleAddTag = () => {
    if (newTag.trim() && !formData.tags.includes(newTag.trim())) {
      setFormData(prev => ({
        ...prev,
        tags: [...prev.tags, newTag.trim()]
      }))
      setNewTag('')
    }
  }

  const handleRemoveTag = (tagToRemove: string) => {
    setFormData(prev => ({
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

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    
    if (!formData.title.trim() || !formData.content.trim()) {
      alert('Please fill in the title and content fields')
      return
    }

    setIsSubmitting(true)
    
    try {
      addMemory({
        title: formData.title.trim(),
        content: formData.content.trim(),
        category: formData.category,
        tags: formData.tags,
        location: formData.location.trim(),
        weather: formData.weather,
        mood: formData.mood || undefined,
        isFavorite: formData.isFavorite
      })
      
      navigate('/')
    } catch (error) {
      console.error('Error creating memory:', error)
      alert('Failed to create memory. Please try again.')
    } finally {
      setIsSubmitting(false)
    }
  }

  return (
    <div className="max-w-4xl mx-auto animate-fade-in">
      {/* Header */}
      <div className="flex items-center justify-between mb-8">
        <div>
          <h1 className="text-3xl font-bold text-gray-900 mb-2">
            Create New Memory
          </h1>
          <p className="text-gray-600">
            Capture this precious moment in your memory bank
          </p>
        </div>
        <button
          onClick={() => navigate('/')}
          className="btn-secondary"
        >
          <X className="w-5 h-5 mr-2" />
          Cancel
        </button>
      </div>

      {/* Form */}
      <form onSubmit={handleSubmit} className="space-y-8">
        <div className="memory-card p-8">
          {/* Title */}
          <div className="mb-6">
            <label htmlFor="title" className="block text-sm font-medium text-gray-700 mb-2">
              Memory Title *
            </label>
            <input
              type="text"
              id="title"
              value={formData.title}
              onChange={(e) => handleInputChange('title', e.target.value)}
              className="input-field text-lg"
              placeholder="Give your memory a meaningful title..."
              required
            />
          </div>

          {/* Content */}
          <div className="mb-6">
            <label htmlFor="content" className="block text-sm font-medium text-gray-700 mb-2">
              Memory Content *
            </label>
            <textarea
              id="content"
              value={formData.content}
              onChange={(e) => handleInputChange('content', e.target.value)}
              className="input-field min-h-[200px] resize-none"
              placeholder="Write about your memory... What happened? How did you feel? What made this moment special?"
              required
            />
          </div>

          {/* Category */}
          <div className="mb-6">
            <label htmlFor="category" className="block text-sm font-medium text-gray-700 mb-2">
              Category
            </label>
            <select
              id="category"
              value={formData.category}
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
          <div className="mb-6">
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
                <Plus className="w-5 h-5" />
              </button>
            </div>
            {formData.tags.length > 0 && (
              <div className="flex flex-wrap gap-2">
                {formData.tags.map((tag, index) => (
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

        {/* Additional Details */}
        <div className="memory-card p-8">
          <h2 className="text-xl font-semibold text-gray-900 mb-6">
            Additional Details
          </h2>
          
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            {/* Location */}
            <div>
              <label htmlFor="location" className="block text-sm font-medium text-gray-700 mb-2">
                <MapPin className="w-4 h-4 inline mr-1" />
                Location
              </label>
              <input
                type="text"
                id="location"
                value={formData.location}
                onChange={(e) => handleInputChange('location', e.target.value)}
                className="input-field"
                placeholder="Where did this happen?"
              />
            </div>

            {/* Weather */}
            <div>
              <label htmlFor="weather" className="block text-sm font-medium text-gray-700 mb-2">
                <Cloud className="w-4 h-4 inline mr-1" />
                Weather
              </label>
              <select
                id="weather"
                value={formData.weather}
                onChange={(e) => handleInputChange('weather', e.target.value)}
                className="input-field"
              >
                <option value="">Select weather...</option>
                {weatherOptions.map(weather => (
                  <option key={weather} value={weather}>
                    {weather}
                  </option>
                ))}
              </select>
            </div>

            {/* Mood */}
            <div>
              <label htmlFor="mood" className="block text-sm font-medium text-gray-700 mb-2">
                <Smile className="w-4 h-4 inline mr-1" />
                Mood
              </label>
              <select
                id="mood"
                value={formData.mood}
                onChange={(e) => handleInputChange('mood', e.target.value)}
                className="input-field"
              >
                <option value="">Select mood...</option>
                {moods.map(mood => (
                  <option key={mood.value} value={mood.value}>
                    {mood.label}
                  </option>
                ))}
              </select>
            </div>

            {/* Favorite */}
            <div className="flex items-center">
              <label className="flex items-center">
                <input
                  type="checkbox"
                  checked={formData.isFavorite}
                  onChange={(e) => handleInputChange('isFavorite', e.target.checked)}
                  className="w-4 h-4 text-primary-600 border-gray-300 rounded focus:ring-primary-500"
                />
                <span className="ml-2 text-sm font-medium text-gray-700">
                  Mark as favorite
                </span>
              </label>
            </div>
          </div>
        </div>

        {/* Submit */}
        <div className="flex justify-end space-x-4">
          <button
            type="button"
            onClick={() => navigate('/')}
            className="btn-secondary"
          >
            Cancel
          </button>
          <button
            type="submit"
            disabled={isSubmitting}
            className="btn-primary disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {isSubmitting ? (
              <>
                <div className="animate-spin rounded-full h-5 w-5 border-b-2 border-white mr-2"></div>
                Creating...
              </>
            ) : (
              <>
                <Save className="w-5 h-5 mr-2" />
                Save Memory
              </>
            )}
          </button>
        </div>
      </form>
    </div>
  )
}

export default CreateMemory
