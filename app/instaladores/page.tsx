export default function Instaladores() {
  return (
    <section>
      <h1 className="mb-8 text-2xl font-semibold tracking-tighter">
        Instaladores de Aplicações
      </h1>
      <div className="grid gap-6">
        <div className="border rounded-lg p-6">
          <h2 className="text-xl font-semibold mb-2">Contatos Leonidio</h2>
          <p className="text-gray-600 mb-4">
            Sistema de gerenciamento de contatos com funcionalidades avançadas.
          </p>
          <div className="flex gap-4">
            <a 
              href="/instaladores/contatosleonidio" 
              className="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded transition-colors"
            >
              Instalar Aplicação
            </a>
            <a 
              href="/instaladores/contatosleonidio" 
              className="border border-gray-300 hover:border-gray-400 px-4 py-2 rounded transition-colors"
            >
              Ver Detalhes
            </a>
          </div>
        </div>
      </div>
    </section>
  )
}

export function generateMetadata() {
  return {
    title: 'Instaladores',
    description: 'Download e instalação de aplicações ClickOnce',
  }
}