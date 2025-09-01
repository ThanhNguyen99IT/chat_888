import { useState, useEffect } from 'react'
import { Search as SearchIcon, Filter, X, Tag, Calendar } from 'lucide-react'
import { useMemory } from '../contexts/MemoryContext'
import MemoryCard from '../components/MemoryCard'

const Search = () => {
  const { searchMemories, getMemoriesByCategory } = useMemory()
  const [searchQuery, setSearchQuery] = useState('')
  const [selectedCategory, setSelectedCategory] = useState<string>('all')
  const [showFilters, setShowFilters] = useState(false)
  const [searchResults, setSearchResults] = useState<any[]>([])

  const categories = [
    { name: 'all', label: 'All Categories' },
    { name: 'Personal', label: 'Personal' },
    { name: 'Travel', label: 'Travel' },
    { name: 'Family', label: 'Family' },
    { name: 'Books', label: 'Books' },
    { name: 'Photos', label: 'Photos' },
    { name: 'Music', label: 'Music' },
  ]

  useEffect(() => {
    let results = []
    
    if (searchQuery.trim()) {
      results = searchMemories(searchQuery)
    } else {
      results = selectedCategory === 'all' 
        ? [] 
        : getMemoriesByCategory(selectedCategory)
    }
    
    setSearchResults(results)
  }, [searchQuery, selectedCategory, searchMemories, getMemoriesByCategory])

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault()
    // Search is handled by useEffect
  }

  const clearSearch = () => {
    setSearchQuery('')
    setSelectedCategory('all')
    setSearchResults([])
  }

  const hasActiveFilters = searchQuery.trim() || selectedCategory !== 'all'

  return (
    <div className="max-w-6xl mx-auto animate-fade-in">
      {/* Header */}
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-2">
          Search Memories
        </h1>
        <p className="text-gray-600">
          Find your precious memories by searching titles, content, tags, or categories
        </p>
      </div>

      {/* Search Form */}
      <div className="memory-card p-6 mb-8">
        <form onSubmit={handleSearch} className="space-y-4">
          <div className="flex gap-4">
            <div className="flex-1 relative">
              <SearchIcon className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
              <input
                type="text"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Search memories..."
                className="input-field pl-10"
              />
            </div>
            <button
              type="button"
              onClick={() => setShowFilters(!showFilters)}
              className={`btn-secondary ${showFilters ? 'bg-primary-50 text-primary-700' : ''}`}
            >
              <Filter className="w-5 h-5 mr-2" />
              Filters
            </button>
            {hasActiveFilters && (
              <button
                type="button"
                onClick={clearSearch}
                className="btn-secondary"
              >
                <X className="w-5 h-5 mr-2" />
                Clear
              </button>
            )}
          </div>

          {/* Filters */}
          {showFilters && (
            <div className="pt-4 border-t border-gray-200">
              <div className="flex items-center space-x-4">
                <span className="text-sm font-medium text-gray-700">Category:</span>
                <div className="flex flex-wrap gap-2">
                  {categories.map((category) => (
                    <button
                      key={category.name}
                      type="button"
                      onClick={() => setSelectedCategory(category.name)}
                      className={`
                        px-3 py-1 rounded-full text-sm font-medium transition-all duration-200
                        ${selectedCategory === category.name
                          ? 'bg-gradient-to-r from-primary-500 to-memory-500 text-white shadow-lg'
                          : 'bg-white/50 text-gray-700 hover:bg-white hover:text-gray-900 border border-white/20'
                        }
                      `}
                    >
                      {category.label}
                    </button>
                  ))}
                </div>
              </div>
            </div>
          )}
        </form>
      </div>

      {/* Search Results */}
      <div>
        <div className="flex items-center justify-between mb-6">
          <h2 className="text-xl font-semibold text-gray-900">
            {hasActiveFilters ? 'Search Results' : 'Recent Memories'}
          </h2>
          {hasActiveFilters && (
            <div className="text-sm text-gray-500">
              {searchResults.length} result{searchResults.length !== 1 ? 's' : ''} found
            </div>
          )}
        </div>

        {!hasActiveFilters ? (
          <div className="memory-card p-12 text-center">
            <SearchIcon className="w-16 h-16 text-gray-300 mx-auto mb-4" />
            <h3 className="text-lg font-medium text-gray-900 mb-2">
              Start searching for your memories
            </h3>
            <p className="text-gray-600 mb-6">
              Enter keywords in the search box above to find specific memories
            </p>
            <div className="flex flex-wrap justify-center gap-2 text-sm text-gray-500">
              <span className="flex items-center">
                <Tag className="w-4 h-4 mr-1" />
                Search by tags
              </span>
              <span className="flex items-center">
                <Calendar className="w-4 h-4 mr-1" />
                Search by date
              </span>
            </div>
          </div>
        ) : searchResults.length === 0 ? (
          <div className="memory-card p-12 text-center">
            <SearchIcon className="w-16 h-16 text-gray-300 mx-auto mb-4" />
            <h3 className="text-lg font-medium text-gray-900 mb-2">
              No memories found
            </h3>
            <p className="text-gray-600 mb-6">
              Try adjusting your search terms or filters to find what you're looking for
            </p>
            <button
              onClick={clearSearch}
              className="btn-primary"
            >
              <X className="w-5 h-5 mr-2" />
              Clear Search
            </button>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {searchResults.map((memory) => (
              <MemoryCard key={memory.id} memory={memory} />
            ))}
          </div>
        )}
      </div>

      {/* Search Tips */}
      {hasActiveFilters && searchResults.length > 0 && (
        <div className="mt-8 memory-card p-6">
          <h3 className="text-lg font-semibold text-gray-900 mb-4">Search Tips</h3>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm text-gray-600">
            <div>
              <h4 className="font-medium text-gray-700 mb-2">Search by content:</h4>
              <ul className="space-y-1">
                <li>• Use keywords from your memory titles</li>
                <li>• Search for specific events or feelings</li>
                <li>• Look for location names or dates</li>
              </ul>
            </div>
            <div>
              <h4 className="font-medium text-gray-700 mb-2">Use tags and categories:</h4>
              <ul className="space-y-1">
                <li>• Filter by memory categories</li>
                <li>• Search for specific tags</li>
                <li>• Combine multiple search terms</li>
              </ul>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}

export default Search
