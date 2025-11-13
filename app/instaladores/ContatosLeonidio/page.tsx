export default function ContatosLeonidioInstaller() {
  return (
    <div className="max-w-4xl mx-auto">
      <div className="bg-white border rounded-lg shadow-sm p-8 text-center">
        <h1 className="text-3xl font-bold mb-6">Contatos Leonidio</h1>
        <p className="text-lg mb-6">Clique no botão abaixo para instalar a aplicação:</p>
        
        <a 
          href="/instaladores/ContatosLeonidio/ContatosLeonidio.application" 
          className="inline-block bg-blue-500 hover:bg-blue-600 text-white px-8 py-4 rounded-lg text-lg font-semibold transition-colors mb-8"
        >
          📥 Instalar Aplicação
        </a>
        
        <div className="text-left">
          <h3 className="text-xl font-semibold mb-4">Instruções de Instalação:</h3>
          <div className="bg-gray-50 border-l-4 border-blue-500 p-4 mb-6">
            <strong>Requisitos:</strong>
            <ul className="list-disc list-inside mt-2 space-y-1">
              <li>.NET Framework ou .NET Core instalado</li>
              <li>Windows 7 ou superior</li>
              <li>Permissões de administrador (se necessário)</li>
            </ul>
          </div>
          
          <p className="font-semibold mb-2">Passos para instalação:</p>
          <ol className="list-decimal list-inside space-y-2 mb-6">
            <li>Clique no botão "Instalar Aplicação" acima</li>
            <li>Se aparecer um aviso de segurança, clique em "Executar mesmo assim" ou "Mais informações" → "Executar mesmo assim"</li>
            <li>Siga as instruções do instalador</li>
            <li>Aguarde a conclusão da instalação</li>
          </ol>
          
          <p className="text-gray-600 italic">
            Nota: Esta aplicação utiliza ClickOnce para instalação e atualizações automáticas.
          </p>
        </div>
      </div>
    </div>
  )
}

export function generateMetadata() {
  return {
    title: 'Contatos Leonidio - Instalação',
    description: 'Download e instalação da aplicação Contatos Leonidio via ClickOnce',
  }
}