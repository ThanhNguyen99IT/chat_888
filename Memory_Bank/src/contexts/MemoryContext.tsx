import React, { createContext, useContext, useReducer, useEffect } from 'react'
import { v4 as uuidv4 } from 'uuid'

export interface Memory {
  id: string
  title: string
  content: string
  category: string
  tags: string[]
  createdAt: Date
  updatedAt: Date
  isFavorite: boolean
  mood?: 'happy' | 'sad' | 'excited' | 'calm' | 'nostalgic' | 'inspired'
  location?: string
  weather?: string
}

interface MemoryState {
  memories: Memory[]
  loading: boolean
  error: string | null
}

type MemoryAction =
  | { type: 'SET_LOADING'; payload: boolean }
  | { type: 'SET_ERROR'; payload: string | null }
  | { type: 'ADD_MEMORY'; payload: Memory }
  | { type: 'UPDATE_MEMORY'; payload: Memory }
  | { type: 'DELETE_MEMORY'; payload: string }
  | { type: 'TOGGLE_FAVORITE'; payload: string }
  | { type: 'LOAD_MEMORIES'; payload: Memory[] }

const initialState: MemoryState = {
  memories: [],
  loading: false,
  error: null
}

const memoryReducer = (state: MemoryState, action: MemoryAction): MemoryState => {
  switch (action.type) {
    case 'SET_LOADING':
      return { ...state, loading: action.payload }
    case 'SET_ERROR':
      return { ...state, error: action.payload }
    case 'ADD_MEMORY':
      return { ...state, memories: [action.payload, ...state.memories] }
    case 'UPDATE_MEMORY':
      return {
        ...state,
        memories: state.memories.map(memory =>
          memory.id === action.payload.id ? action.payload : memory
        )
      }
    case 'DELETE_MEMORY':
      return {
        ...state,
        memories: state.memories.filter(memory => memory.id !== action.payload)
      }
    case 'TOGGLE_FAVORITE':
      return {
        ...state,
        memories: state.memories.map(memory =>
          memory.id === action.payload
            ? { ...memory, isFavorite: !memory.isFavorite }
            : memory
        )
      }
    case 'LOAD_MEMORIES':
      return { ...state, memories: action.payload }
    default:
      return state
  }
}

interface MemoryContextType {
  state: MemoryState
  addMemory: (memory: Omit<Memory, 'id' | 'createdAt' | 'updatedAt'>) => void
  updateMemory: (id: string, updates: Partial<Memory>) => void
  deleteMemory: (id: string) => void
  toggleFavorite: (id: string) => void
  getMemory: (id: string) => Memory | undefined
  searchMemories: (query: string) => Memory[]
  getMemoriesByCategory: (category: string) => Memory[]
  getFavoriteMemories: () => Memory[]
}

const MemoryContext = createContext<MemoryContextType | undefined>(undefined)

export const useMemory = () => {
  const context = useContext(MemoryContext)
  if (!context) {
    throw new Error('useMemory must be used within a MemoryProvider')
  }
  return context
}

export const MemoryProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [state, dispatch] = useReducer(memoryReducer, initialState)

  // Load memories from localStorage on mount
  useEffect(() => {
    const savedMemories = localStorage.getItem('memories')
    if (savedMemories) {
      try {
        const memories = JSON.parse(savedMemories).map((memory: any) => ({
          ...memory,
          createdAt: new Date(memory.createdAt),
          updatedAt: new Date(memory.updatedAt)
        }))
        dispatch({ type: 'LOAD_MEMORIES', payload: memories })
      } catch (error) {
        console.error('Error loading memories:', error)
        dispatch({ type: 'SET_ERROR', payload: 'Failed to load memories' })
      }
    }
  }, [])

  // Save memories to localStorage whenever they change
  useEffect(() => {
    localStorage.setItem('memories', JSON.stringify(state.memories))
  }, [state.memories])

  const addMemory = (memoryData: Omit<Memory, 'id' | 'createdAt' | 'updatedAt'>) => {
    const newMemory: Memory = {
      ...memoryData,
      id: uuidv4(),
      createdAt: new Date(),
      updatedAt: new Date()
    }
    dispatch({ type: 'ADD_MEMORY', payload: newMemory })
  }

  const updateMemory = (id: string, updates: Partial<Memory>) => {
    const memory = state.memories.find(m => m.id === id)
    if (memory) {
      const updatedMemory = {
        ...memory,
        ...updates,
        updatedAt: new Date()
      }
      dispatch({ type: 'UPDATE_MEMORY', payload: updatedMemory })
    }
  }

  const deleteMemory = (id: string) => {
    dispatch({ type: 'DELETE_MEMORY', payload: id })
  }

  const toggleFavorite = (id: string) => {
    dispatch({ type: 'TOGGLE_FAVORITE', payload: id })
  }

  const getMemory = (id: string) => {
    return state.memories.find(memory => memory.id === id)
  }

  const searchMemories = (query: string) => {
    const lowercaseQuery = query.toLowerCase()
    return state.memories.filter(memory =>
      memory.title.toLowerCase().includes(lowercaseQuery) ||
      memory.content.toLowerCase().includes(lowercaseQuery) ||
      memory.tags.some(tag => tag.toLowerCase().includes(lowercaseQuery)) ||
      memory.category.toLowerCase().includes(lowercaseQuery)
    )
  }

  const getMemoriesByCategory = (category: string) => {
    return state.memories.filter(memory => memory.category === category)
  }

  const getFavoriteMemories = () => {
    return state.memories.filter(memory => memory.isFavorite)
  }

  const value: MemoryContextType = {
    state,
    addMemory,
    updateMemory,
    deleteMemory,
    toggleFavorite,
    getMemory,
    searchMemories,
    getMemoriesByCategory,
    getFavoriteMemories
  }

  return (
    <MemoryContext.Provider value={value}>
      {children}
    </MemoryContext.Provider>
  )
}
