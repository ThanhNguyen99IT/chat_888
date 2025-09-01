import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'
import { MemoryProvider } from './contexts/MemoryContext'
import Layout from './components/Layout'
import Dashboard from './pages/Dashboard'
import MemoryDetail from './pages/MemoryDetail'
import CreateMemory from './pages/CreateMemory'
import Search from './pages/Search'

function App() {
  return (
    <MemoryProvider>
      <Router>
        <div className="min-h-screen bg-gradient-to-br from-primary-50 to-memory-50">
          <Layout>
            <Routes>
              <Route path="/" element={<Dashboard />} />
              <Route path="/memory/:id" element={<MemoryDetail />} />
              <Route path="/create" element={<CreateMemory />} />
              <Route path="/search" element={<Search />} />
            </Routes>
          </Layout>
        </div>
      </Router>
    </MemoryProvider>
  )
}

export default App
