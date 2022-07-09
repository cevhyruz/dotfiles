require( 'user.options' )

require( 'user.maputils' ).init()

require( 'user.abbrev' )

require( 'user.packages' )

require( 'lsp' )

require( 'user.note' )

require( 'user.utils' )

package.path = package.path .. ';' .. vim.fn.getenv('DOTFILES') .. '/localrc/'
require( 'localrc.localrc' )
