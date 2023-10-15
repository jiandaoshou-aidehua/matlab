classdef PEG < handle














































    properties ( Access = private )
        g;
        breaks = zeros( 3, 0 );
    end

    properties
        root = 1;
        rules
    end

    methods

        function p = PEG( rules, root )
            arguments
                rules
                root( 1, 1 )string = ""
            end
            if ~iscell( rules )
                rules = readRuleFile( rules );
            end
            [ cells, p.rules ] = splitrules( rules );
            if nargin > 1
                p.root = setRoot( cells, root );
            end
            state.names = cells( 1, : );
            state.inlines = cells( 5, : );
            for k = 1:size( cells, 2 )
                state.codes = cells( 3, : );
                state.str = cells{ 2, k };
                state.n = 1;
                code = compile( state );
                if cells{ 4, k } ~= 1
                    code = genRecord( code, cells{ 4, k } );
                end
                cells{ 3, k } = code;
            end
            abbrevs = cells( 5, : );
            abbrevs( cellfun( @( x )isempty( x ), abbrevs ) ) = [  ];
            [ uniqueAbbrevs, inds ] = unique( abbrevs );
            if length( uniqueAbbrevs ) ~= length( abbrevs )
                dups = abbrevs( setdiff( 1:length( abbrevs ), inds ) );
                error( message( 'shared_pegparserlib:PEG:DuplicateAbbreviations', sprintf( '%s ', dups{ : } ) ) );
            end
            p.g = struct( 'name', cells( 1, : ), 'def', cells( 2, : ),  ...
                'code', cells( 3, : ), 'record', cells( 4, : ),  ...
                'abbrev', cells( 5, : ) );
        end

        function r = rulemap( parser )




            n = { parser.g( : ).name };
            v = num2cell( 1:length( n ) );
            w = [ n;v ];
            r = struct( w{ : } );
        end

        function s = name( parser, n )




            s = parser.g( n ).name;
        end

        function defn = definition( parser, rule )




            rulen = ruleNumber( parser, rule );
            p = parser.g;
            defn = p( rulen ).def;
        end

        function dbstop( parser, rule, at )








            narginchk( 2, 3 );
            if nargin == 2
                at = 1;
            end
            rulen = ruleNumber( parser, rule );
            p = parser.g;
            code = p( rulen ).code;
            op = code( at );
            if op ~= 20
                parser.g( rulen ).code( at ) = 20;
                parser.breaks( :, end  + 1 ) = [ rulen;at;op ];
            end
        end

        function dbstatus( parser )




            rs = rulemap( parser );
            allnames = fieldnames( rs );
            b = parser.breaks;
            vnames = allnames( b( 1, : ) );
            vlocs = num2cell( b( 2, : ) );
            counts = num2cell( 1:size( b, 2 ) );
            vals = [ counts;vnames( : ).';vlocs ];
            len = max( cellfun( 'length', vnames ) );
            space = num2str( ceil( len / 5 ) * 5 );
            fprintf( [ '%2d. %', space, 's %3d\n' ], vals{ : } );
        end

        function dbclear( parser, n )





            b = parser.breaks;
            n = n( : ).';
            for k = n
                c = b( :, k );
                parser.g( c( 1 ) ).code( c( 2 ) ) = c( 3 );
            end
            parser.breaks( :, n ) = [  ];
        end

        function out = pretty( parser, tree, str, width )







            len = size( tree, 2 );
            rs = rulemap( parser );
            names = fieldnames( rs );
            if nargout == 1
                out = '';
            end
            maxlen = 40;
            if nargin > 3
                maxlen = width;
            end
            for k = 1:len
                node = tree( :, k );
                name = names{ node( 1 ) };
                depth = 1;
                k1 = k;
                while k1 > 0
                    k1 = k1 - max( 1, tree( 4, k1 ) );
                    depth = depth + 1;
                end
                indent = repmat( ' ', 1, depth );
                if nargin > 2
                    lit = str( node( 2 ):node( 3 ) );
                    lit( lit < 32 | lit > 127 ) = ' ';
                    lit = regexprep( lit, '[ ]+', ' ' );
                    if length( lit ) > maxlen
                        lit = [ lit( 1:maxlen - 10 ), ' ... ', lit( end  - 10:end  ) ];
                    end
                    literal = [ '''', lit, '''' ];
                else
                    literal = '';
                end
                if nargout == 1
                    out = sprintf( '%s%s%s %s\n', out, indent, name, literal );
                else
                    fprintf( '%s%s %s\n', indent, name, literal );
                end
            end
        end

        function header = formatJavaScriptHeader( ~, endYear )
            if nargin == 1
                endYear = year( datetime( 'now' ) );
            end
            copyrightLine = sprintf( '// Copyright 2014-%d The MathWorks, Inc\n\n', endYear );
            header = [  ...
                copyrightLine ...
                , '// Machine generated by matlab.internal.pegparser.PEG.\n' ...
                , '// To reproduce, run\n' ...
                , '//  p = matlab.internal.pegparser.PEG(''rule file'');\n' ...
                , '//  diary on\n' ...
                , '//  p.formatForJavaScript\n' ...
                , '//  diary off\n' ...
                , '// edit the diary to remove the MATLAB commands at the start and end\n' ...
                , '// and rename the file as needed.\n\n' ...
                ];
        end

        function formatForJavaScript( parser, filename, header )







            if nargin < 2
                fid = 1;
            else
                fid = fopen( filename, 'w' );
                cleanup = onCleanup( @(  )fclose( fid ) );
            end
            if nargin < 3
                header = formatJavaScriptHeader( parser );
            end
            p = parser.g;
            names = '';
            codes = '';
            m = 1;
            mc = 1;
            for k = 1:length( p )
                str = sprintf( '%d, ', p( k ).code );
                str( end  - 1:end  ) = [  ];
                if length( codes( mc:end  ) ) > 50
                    codes( end  ) = [  ];
                    codes = sprintf( '%s\n            ', codes );
                    mc = length( codes );
                end
                codes = sprintf( '%s[%s], ', codes, str );
                if length( names( m:end  ) ) > 50
                    names( end  ) = [  ];
                    names = sprintf( '%s\n            ', names );
                    m = length( names );
                end
                name = p( k ).abbrev;
                if isempty( name )
                    name = p( k ).name;
                end
                names = sprintf( '%s"%s", ', names, name );
            end
            fprintf( fid, header );
            fprintf( fid, 'define([], function () {\n' );
            fprintf( fid, '    return {\n' );
            fprintf( fid, '        rulenames: [\n' );
            fprintf( fid, '            %s\n', names( 1:end  - 2 ) );
            fprintf( fid, '        ],\n' );
            fprintf( fid, '/*eslint-disable max-len*/\n' );
            fprintf( fid, '        rules: [\n' );
            fprintf( fid, '            %s\n', codes( 1:end  - 2 ) );
            fprintf( fid, '        ]\n' );
            fprintf( fid, '/*eslint-enable max-len*/\n' );
            fprintf( fid, '    };\n' );
            fprintf( fid, '});\n' );
        end

        function [ data, strCounts ] = profile( parser, str )








            [ ~, ~, ~, cprofdata ] = applyPriv( parser, str, true, false );
            profdata = cprofdata{ 1 };
            strCounts = cprofdata{ 2 };
            z = find( profdata( 2, : ) == 0 );
            names = { parser.g( : ).name };
            names( z ) = [  ];
            profdata( :, z ) = [  ];
            [ ~, inds ] = sort( profdata( 2, : ), 'descend' );
            profdata = profdata( :, inds );
            names = names( inds );
            if nargout == 0
                vals = cellfun( @( x )sprintf( '%6d ', x ), num2cell( profdata, 1 ), 'UniformOutput', false );
                pairs = [ names;vals ];
                fprintf( '%20s   Calls   Time   Fails\n', ' ' );
                str = sprintf( '%20s: %s\n', pairs{ : } );
                fprintf( '%s', str );
            else
                profdata = num2cell( profdata.', 2 ).';
                pairs = [ names;profdata ];
                data = struct( pairs{ : } );
            end
        end

        function tree = parse( parser, str, trace )


            arguments
                parser( 1, 1 )matlab.internal.pegparser.PEG
                str( 1, 1 )string
                trace( 1, 1 )logical = false
            end
            str = char( str );

            try
                if nargin < 3 && isempty( parser.breaks )
                    [ ~, ~, matches ] = matlab.internal.pegparser.pegapply( parser.g, str, parser.root );
                else
                    if nargin < 3
                        trace = false;
                    end
                    [ ~, ~, matches ] = applyPriv( parser, str, false, trace );
                end
            catch ex
                throw( ex )
            end
            if ~isempty( matches )
                matches( 4, 1 ) = 1;
            end
            tree = matches;
        end

        function disassemble( parser, routine, mark )









            p = parser.g;
            rs = rulemap( parser );
            if iscell( routine )
                allnames = fieldnames( rs );
                routine = cellfun( @( s )find( strcmp( s, allnames ), 1 ), routine );
            elseif ischar( routine )
                routine = rs.( routine );
            end
            if nargin == 2
                mark = inf;
            end
            if length( routine ) > 1
                routine = routine( : ).';
                for k = routine
                    disassemble( parser, k );
                    fprintf( '\n' );
                end
                return
            end

            depth = 0;


            ip = 1;


            code = p( routine ).code;
            fprintf( '%s\n', p( routine ).name );
            while ip <= length( code )
                cmd = code( ip );
                if cmd == 20
                    cmd = findOpCode( parser.breaks, routine, ip );
                    depth = depth + 1i;
                end
                if ip == mark
                    depth = depth + 100i;
                end
                switch cmd
                    case 0
                        printLine( depth, ip, 'begin' );
                        depth = depth + 1;
                        ip = ip + 1;
                    case 1
                        depth = depth - 1;
                        printLine( depth, ip, 'end' );
                        ip = ip + 1;
                    case 2
                        addr = code( ip + 1 );
                        name = p( addr ).name;
                        printLine( depth, ip, 'call %s(%d)', name, addr );
                        ip = ip + 2;
                    case 3
                        len = code( ip + 1 );
                        lit = char( code( ip + 2:ip + 1 + len ) );
                        printLine( depth, ip, 'literal %s', lit );
                        ip = ip + 2 + len;
                    case 4
                        depth = depth - 1;
                        printLine( depth, ip, 'end optional' );
                        ip = ip + 1;
                    case 5
                        offset = code( ip + 1 );
                        depth = depth - 1;
                        printLine( depth, ip, 'end one-or-more (branch %d)', ip + offset );
                        ip = ip + 2;
                    case 6
                        offset = code( ip + 1 );
                        depth = depth - 1;
                        printLine( depth, ip, 'end zero-or-more (branch %d)', ip + offset );
                        ip = ip + 2;
                    case 7
                        printLine( depth, ip, 'not lookahead' );
                        ip = ip + 1;
                    case 8
                        printLine( depth, ip, 'lookahead' );
                        ip = ip + 1;
                    case 9
                        printLine( depth, ip, 'push counter' );
                        ip = ip + 1;
                    case 10
                        offset = code( ip + 1 );
                        printLine( depth, ip, 'followed by (branch %d)', ip + offset );
                        ip = ip + 2;
                    case 11
                        offset = code( ip + 1 );
                        printLine( depth, ip, 'choice (branch %d)', ip + offset );
                        ip = ip + 2;
                    case 12
                        lit = code( ip + 1 );
                        printLine( depth, ip, 'literal token %d', lit );
                        ip = ip + 2;
                    case 13
                        lit = code( ip + 1 );
                        printLine( depth, ip, 'record %d', lit );
                        ip = ip + 2;
                    case 14
                        printLine( depth, ip, 'empty' );
                        ip = ip + 1;
                    case 15
                        lit = code( ip + 1 );
                        printLine( depth, ip, 'literal unicode %s', dec2hex( lit ) );
                        ip = ip + 2;
                    case { 16, 17 }
                        len = code( ip + 1 );
                        str = '';
                        for k = 1:len
                            low = code( ip + k * 2 );
                            hi = code( ip + 1 + k * 2 );
                            str = sprintf( '%s%s-%s ', str, dec2hex( low ), dec2hex( hi ) );
                        end
                        not = '';
                        if cmd == 17
                            not = 'not ';
                        end
                        str( end  ) = [  ];
                        printLine( depth, ip, 'range %s%s', not, str );
                        ip = ip + 2 + len * 2;
                    case 18
                        depth = depth - 1;
                        printLine( depth, ip, 'unless (branch %d)', ip + 3 + code( ip + 1 ) );
                        depth = depth + 1;
                        ip = ip + 2;
                    case 19
                        depth = depth - 1;
                        printLine( depth, ip, 'end unless' );
                        ip = ip + 1;
                    case 21
                        printLine( depth, ip, 'any' );
                        ip = ip + 1;
                    case 26
                        printLine( depth, ip, 'end-of-input' );
                        ip = ip + 1;
                    otherwise
                        error( message( 'shared_pegparserlib:PEG:UnknownOpcode', cmd ) );
                end
                depth = real( depth );
            end
            if ip == mark
                depth = depth + 100i;
            end
            printLine( depth, ip, 'return' );
        end

    end

    methods ( Access = private )
        function rulen = ruleNumber( parser, rule )
            if ischar( rule )
                rs = rulemap( parser );
                rulen = rs.( rule );
            else
                rulen = rule;
            end

        end

        function [ accept, res, matches, profdata ] = applyPriv( parser, str, profile, trace )


            p = parser.g;

            profdata = {  };
            accept = true;
            rootn = parser.root;


            code = p( rootn ).code;







            s.stack = [  ];



            s.treeStack = [  ];
            s.tree = zeros( 5, 0 );


            s.calls = [ 1;inf;rootn ];



            s.strs = {  };


            pos = 1;
            tpos = 1;


            ip = 1;

            if profile

                counts = zeros( [ 3, length( p ) ] );
                counts( 1, rootn ) = 1;
                str_counts = zeros( [ 1, length( str ) + 1 ] );
            end

            recursionLimit = 500;


            debugging = false;

            while ~done( s )
                origDebugging = false;
                if debugging
                    origDebugging = true;
                    [ debugging, quitting ] = debugState( parser, s, pos, ip, accept, str );
                    if quitting
                        matches = [  ];
                        res = 0;
                        return
                    end

                    p = parser.g;
                    code = p( s.calls( 3, end  ) ).code;
                end
                if ip > length( code )

                    if size( s.calls, 2 ) > 1
                        caller = s.calls( 3, end  - 1 );
                        code = p( caller ).code;
                        ip = s.calls( 2, end  );
                        if trace && accept
                            name = p( s.calls( 3, end  ) ).name;
                            substr = str( pos:min( pos + 20, length( str ) ) );
                            substr( substr >= 10 & substr <= 13 ) = [  ];

                            printTrace( size( s.calls, 2 ) - 1, '%s pos %d:%d  <%s>', name, s.stack( end  ), pos, substr );
                        end
                        if ~accept
                            pos = s.stack( end  );
                            tpos = s.treeStack( end  );
                            if profile
                                counts( 3, s.calls( 3, end  ) ) = counts( 3, s.calls( 3, end  ) ) + 1;
                            end
                        end
                        s.stack( end  ) = [  ];
                        s.treeStack( end  ) = [  ];
                    end
                    s.calls( :, end  ) = [  ];
                    continue ;
                end
                cmd = code( ip );
                if origDebugging && cmd == 20
                    cmd = findOpCode( parser.breaks, s.calls( 3, end  ), ip );
                end
                if profile
                    counts( 2, s.calls( 3, end  ) ) = counts( 2, s.calls( 3, end  ) ) + 1;
                    if isempty( s.strs )
                        str_counts( pos ) = str_counts( pos ) + 1;
                    end
                end
                switch cmd
                    case 0
                        s.stack( end  + 1 ) = pos;
                        s.treeStack( end  + 1 ) = tpos;
                        ip = ip + 1;
                    case 1
                        if ~accept
                            pos = s.stack( end  );
                            tpos = s.treeStack( end  );
                        end
                        s.stack( end  ) = [  ];
                        s.treeStack( end  ) = [  ];
                        ip = ip + 1;
                    case 2
                        addr = code( ip + 1 );
                        ip = ip + 2;
                        if trace
                            name = p( addr ).name;
                            printTrace( size( s.calls, 2 ), '%s pos(%d)', name, pos );
                        end
                        code = p( addr ).code;
                        s.stack( end  + 1 ) = pos;
                        s.treeStack( end  + 1 ) = tpos;
                        s.calls( :, end  + 1 ) = [ pos;ip;addr ];
                        ip = 1;
                        if profile
                            counts( 1, addr ) = counts( 1, addr ) + 1;
                        end
                        if size( s.calls, 2 ) >= recursionLimit
                            error( message( 'shared_pegparserlib:PEG:Recursion', '' ) );
                        end
                    case 3
                        len = code( ip + 1 );
                        lit = char( code( ip + 2:ip + 1 + len ) );
                        if pos > length( str )
                            accept = false;
                        else
                            accept = strncmp( str( pos:end  ), lit, len );
                        end
                        if accept
                            pos = pos + len;
                        end
                        ip = ip + 2 + len;
                    case 4
                        if ~accept
                            pos = s.stack( end  );
                            tpos = s.treeStack( end  );
                        end
                        accept = true;
                        s.stack( end  ) = [  ];
                        s.treeStack( end  ) = [  ];
                        ip = ip + 1;
                    case 5
                        if accept
                            ip = ip + code( ip + 1 );
                            s.stack( end  ) = pos;
                            s.treeStack( end  ) = tpos;

                            s.stack( end  - 1 ) = 1;
                        else
                            ip = ip + 2;
                            pos = s.stack( end  );
                            tpos = s.treeStack( end  );
                            accept = s.stack( end  - 1 ) > 0;
                            s.stack( end  - 1:end  ) = [  ];
                            s.treeStack( end  ) = [  ];
                        end
                    case 6
                        if accept
                            ip = ip + code( ip + 1 );
                            s.stack( end  ) = pos;
                            s.treeStack( end  ) = tpos;
                        else
                            ip = ip + 2;
                            pos = s.stack( end  );
                            s.stack( end  ) = [  ];
                            tpos = s.treeStack( end  );
                            s.treeStack( end  ) = [  ];
                            accept = true;
                        end
                    case { 7, 8 }
                        if cmd == 7
                            accept = ~accept;
                        end
                        pos = s.stack( end  );
                        s.stack( end  ) = [  ];
                        tpos = s.treeStack( end  );
                        s.treeStack( end  ) = [  ];
                        ip = ip + 1;
                    case 9
                        s.stack( end  + 1 ) = 0;
                        ip = ip + 1;
                    case 10
                        if accept
                            ip = ip + 2;
                        else
                            pos = s.stack( end  );
                            s.stack( end  ) = [  ];
                            tpos = s.treeStack( end  );
                            s.treeStack( end  ) = [  ];
                            ip = ip + code( ip + 1 );
                        end
                    case 11
                        if ~accept
                            ip = ip + 2;
                        else
                            s.stack( end  ) = [  ];
                            s.treeStack( end  ) = [  ];
                            ip = ip + code( ip + 1 );
                        end
                    case { 12, 15 }
                        tok = code( ip + 1 );
                        if pos > length( str )
                            accept = false;
                        else
                            accept = double( str( pos ) ) == double( tok );
                        end
                        if accept
                            pos = pos + 1;
                        end
                        ip = ip + 2;
                    case 13
                        if accept
                            recordStyle = code( ip + 1 );

                            rule = s.calls( 3, end  );
                            if isempty( s.stack )
                                startpos = 1;
                            else
                                startpos = s.stack( end  );
                            end
                            if isempty( s.treeStack )
                                bodysize = tpos - 1;
                            else
                                bodysize = tpos - s.treeStack( end  );
                            end







                            head = [ rule;startpos;pos - 1;0;bodysize + 1 ];

                            if recordStyle == 0 && bodysize > 0 && tpos > 1 && bodysize == s.tree( 5, tpos - 1 )







                            else
                                s.tree = setParentOffsets( s.tree, bodysize, tpos - 1 );
                                s.tree( :, tpos ) = head;
                                tpos = tpos + 1;
                            end
                        end
                        ip = ip + 2;
                    case 14
                        accept = true;
                        ip = ip + 1;
                    case { 16, 17 }
                        len = code( ip + 1 );
                        if pos > length( str )
                            accept = false;
                        else
                            ch = double( str( pos ) );
                            for k = 1:len
                                low = code( ip + k * 2 );
                                hi = code( ip + 1 + k * 2 );
                                accept = ch >= low && ch <= hi;
                                if accept
                                    break ;
                                end
                            end
                            if cmd == 17
                                accept = ~accept;
                            end
                        end
                        if accept
                            pos = pos + 1;
                        end
                        ip = ip + 2 + len * 2;
                    case 18
                        if ~accept
                            ip = ip + 3 + code( ip + 1 );
                            pos = s.stack( end  );
                            s.stack( end  ) = [  ];
                            tpos = s.treeStack( end  );
                            s.treeStack( end  ) = [  ];
                        else

                            s.strs( end  + 1 ) = { str };
                            str = str( s.stack( end  ):pos - 1 );
                            pos = 1;
                            ip = ip + 2;
                        end
                    case 19
                        if pos ~= length( str ) + 1 || ~accept
                            pos = s.stack( end  ) + length( str );
                            accept = true;
                        else
                            pos = s.stack( end  );
                            accept = false;
                        end
                        str = s.strs{ end  };
                        s.strs( end  ) = [  ];
                        s.stack( end  ) = [  ];
                        tpos = s.treeStack( end  );
                        s.treeStack( end  ) = [  ];
                        ip = ip + 1;
                    case 20
                        debugging = true;
                        printDebugState( parser, s, pos, ip, accept, str )
                    case 21
                        accept = pos <= length( str );
                        if accept
                            pos = pos + 1;
                        end
                        ip = ip + 1;
                    case 26
                        accept = pos == length( str ) + 1;
                        ip = ip + 1;
                    otherwise
                        error( message( 'shared_pegparserlib:PEG:UnknownOpcode', cmd ) );
                end
            end
            if accept
                res = pos - 1;
                matches = fliptree( s.tree, tpos - 1 );
                if profile
                    profdata = { counts, str_counts };
                end
            else
                res = 0;
                matches = zeros( 5, 0 );
            end
        end
    end

    methods ( Static )

        function p = parent( t, n )



            p = n - t( 4, n );
        end

        function n = next( t, n )




            n = n + t( 5, n );
        end

        function str = string( t, n, tstr )
            str = tstr( t( 2, n ):t( 3, n ) );
        end

    end
end


function y = done( s )
y = isempty( s.calls );
end

function t2 = fliptreeR( t1, t2, p1, p2 )
t2( :, p2 ) = t1( :, p1 );
len = t1( 5, p1 );
childs = [  ];
p1 = p1 - 1;
while len > 1
    childs( end  + 1 ) = p1;%#ok
    chlen = t1( 5, p1 );
    p1 = p1 - chlen;
    len = len - chlen;
end
childs = fliplr( childs );
p2 = p2 + 1;
len = 1;
for p1 = childs
    chlen = t1( 5, p1 );
    t2 = fliptreeR( t1, t2, p1, p2 );
    t2( 4, p2 ) = len;
    p2 = p2 + chlen;
    len = len + chlen;
end
end

function out = fliptree( tree, pos )
if pos > 0
    out = zeros( 5, pos );
    out = fliptreeR( tree, out, pos, 1 );
    out( 4, 1 ) = 1;
else
    out = tree;
end
end

function tree = setParentOffsets( tree, bodysize, start )
offset = 1;
while bodysize > 0
    childsize = tree( 5, start );
    tree( 4, start ) = offset;
    bodysize = bodysize - childsize;
    start = start - childsize;
    offset = offset + childsize;
end
end

function [ cells, stringForm ] = splitrules( rules )





rules = cellfun( @strtrim, rules, 'UniformOutput', false );
blanks = cellfun( @( x )isempty( x ), rules );
rules( blanks ) = [  ];
comments = cellfun( @( x )~isempty( regexp( x, '^%', 'once' ) ), rules );
rules( comments ) = [  ];
stringForm = reshape( rules, [  ], 1 );

len = length( rules );
cells = cell( 7, len );
for k = 1:len
    rule = strtrim( rules{ k } );
    p1 = regexp( rule, '^[+-]? *(\w+) *(\( *\w+ *\))? *= *(.*)$', 'tokens' );
    match = p1{ 1 };
    ruleName = match{ 1 };
    modifier = match{ 2 };
    defn = match{ 3 };
    modifier = replace( modifier, ' ', '' );
    abbrev = modifier( 2:end  - 1 );
    if startsWith( rule, '-' )
        style = 1;
    elseif startsWith( rule, '+' )
        style = 2;
    else
        style = 0;
    end
    cells( [ 1, 2, 4, 5 ], k ) = { ruleName, defn, style, abbrev };
end
end

function [ code, s ] = compile( s )
[ code, s ] = compileDiff( s );
fixups = [  ];
while s.n < length( s.str ) && s.str( s.n ) == '/'
    s = skipWS( s, s.n + 1 );
    [ code1, s ] = compileDiff( s );
    [ code, fixups ] = genOr( code, code1, fixups );
end

if ~isempty( fixups )

    code = [ code, genPop ];
end
end

function [ code, s ] = compileDiff( s )
[ code, s ] = compileSeq( s );
s = skipWS( s, s.n );
if s.n < length( s.str ) && s.str( s.n ) == '-'
    s = skipWS( s, s.n + 1 );
    [ c1, s ] = compileSeq( s );
    code = genSetDiff( code, c1 );
end
end

function [ code, s ] = compileSeq( s )
[ code, s ] = compilePrefix( s );
fixups = [  ];
while s.n <= length( s.str ) && ~any( s.str( s.n ) == '/)-' )
    [ code1, s ] = compilePrefix( s );
    if ~isempty( code1 )
        [ code, fixups ] = genSeq( code, code1, fixups );
    end
end

if ~isempty( fixups )

    code = [ code, genPop ];
end
end


function [ code, s ] = compilePrefix( s )
s = skipWS( s, s.n );
ch = s.str( s.n );
if ch == '!'
    s = skipWS( s, s.n + 1 );
    [ code, s ] = compilePostfix( s );
    code = genNegate( code );
elseif ch == '&'
    s = skipWS( s, s.n + 1 );
    [ code, s ] = compilePostfix( s );
    code = genAnd( code );
else
    [ code, s ] = compilePostfix( s );
end
end


function [ code, s ] = compilePostfix( s )
[ code, s ] = compileExpr( s );
if s.n > length( s.str )
    return ;
end
ch = s.str( s.n );
if ch == '*'
    code = genStar( code );
    s = skipWS( s, s.n + 1 );
elseif ch == '+'
    code = genPlus( code );
    s = skipWS( s, s.n + 1 );
elseif ch == '?'
    code = genOptional( code );
    s = skipWS( s, s.n + 1 );
end
end

function [ code, s ] = compileExpr( s )
ch = s.str( s.n );
if ch == '('
    s = skipWS( s, s.n + 1 );
    [ code, s ] = compileGroup( s );
elseif ch == '"' || ch == ''''
    lit = getLiteral( s.str( s.n + 1:end  ), ch );
    code = genLiteral( lit );
    s = skipWS( s, s.n + 2 + length( lit ) );
elseif any( ch == [ 'a':'z', 'A':'Z' ] )
    ident = regexp( s.str( s.n:end  ), '^\w+', 'match' );
    code = genCall( ident{ 1 }, s.names );
    s = skipWS( s, s.n + length( ident{ 1 } ) );
elseif any( ch == '0':'9' )
    lit = getLiteralToken( s.str( s.n:end  ) );
    code = genLiteralToken( lit );
    s = skipWS( s, s.n + length( lit ) );
elseif ch == '#'
    s.n = s.n + 1;
    expect( 'x', s );
    [ lit, n ] = getUnicode( s.str( s.n + 1:end  ) );
    code = genUnicode( lit );
    s = skipWS( s, s.n + n + 1 );
elseif ch == '.'
    code = genAnyChar(  );
    s = skipWS( s, s.n + 1 );
elseif ch == '$'
    code = genEndOfInput(  );
    s = skipWS( s, s.n + 1 );
elseif ch == '['
    s.n = s.n + 1;
    negate = s.str( s.n ) == '^';
    if negate
        s.n = s.n + 1;
    end
    [ lit, n ] = getUnicodeRange( s.str( s.n:end  ) );
    code = genUnicodeRange( lit, negate );
    s.n = s.n + n;
    expect( ']', s );
    s = skipWS( s, s.n + 1 );
elseif ~any( ch == '/)*+?!&-' )
    error( message( 'shared_pegparserlib:PEG:UnexpectedCharacter', ch, s.str, s.n ) );
else
    code = genEmpty;
end
end

function [ code, s ] = compileGroup( s )
[ code, s ] = compile( s );
s = skipWS( s, s.n );
expect( ')', s );
s = skipWS( s, s.n + 1 );
end

function b = isWord( s, word )
s1 = s.str( s.n:end  );
b = strncmp( s1, word, length( word ) );
end

function expect( c, s )
if ~isWord( s, c )
    error( message( 'shared_pegparserlib:PEG:ExpectedWord', c, s.str, s.n ) );
end
end

function c = genPush
c = 0;
end

function c = genPop
c = 1;
end

function c = genCall( ident, names )
n = find( strcmp( ident, names ) );
if ~isscalar( n )
    error( message( 'shared_pegparserlib:PEG:UndefinedRule', ident ) );
end
c = [ 2, n ];
end

function c = genLiteral( ch )
c = [ 3, length( ch ), double( ch ) ];
end

function c = genOptional( c )
c = [ genPush, c, 4 ];
end

function c = genPlus( c )

c = [ genPushCounter, genPush, c, 5,  - length( c ) ];
end

function c = genStar( c )
c = [ genPush, c, 6,  - length( c ) ];
end

function c = genNegate( c )
c = [ genPush, c, 7 ];
end

function c = genAnd( c )
c = [ genPush, c, 8 ];
end

function c = genPushCounter
c = 9;
end

function [ c, fixups ] = genSeq( c1, c2, fixups )
c1 = fixup( c1, fixups, 2 + length( c2 ) );
if isempty( fixups )
    c1 = [ genPush, c1 ];
end
fixups = [ fixups, length( c1 ) + 2 ];
c = [ c1, 10, length( c2 ) + 3, c2 ];
end

function [ c, fixups ] = genOr( c1, c2, fixups )
c1 = fixup( c1, fixups, 2 + length( c2 ) );
if isempty( fixups )

    c1 = [ genPush, c1 ];
end
fixups = [ fixups, length( c1 ) + 2 ];
c = [ c1, 11, length( c2 ) + 3, c2 ];
end

function c = genLiteralToken( ch )
c = [ 12, str2double( ch ) ];
end

function c = genRecord( c, kind )
c = [ c, 13, kind ];
end

function c = genEmpty
c = 14;
end

function c = genUnicode( ch )
c = [ 15, double( ch ) ];
end

function c = genUnicodeRange( ch, negate )
ch = double( ch );
if negate
    cmd = 17;
else
    cmd = 16;
end
c = [ cmd, size( ch, 2 ), ch( : ).' ];
end

function c = genSetDiff( c1, c2 )
c = [ genPush, c1, 18, length( c2 ), c2, 19 ];
end



function c = genAnyChar
c = 21;
end

function c = genEndOfInput
c = 26;
end

function code = fixup( code, locs, offset )
code( locs ) = code( locs ) + offset;
end

function str = getLiteral( str, ch )
dq = find( str == ch, 1 );
str = str( 1:dq - 1 );
end

function str = getLiteralToken( str )
dq = 2;
while dq <= length( str ) && any( str( dq ) == '0':'9' )
    dq = dq + 1;
end
str = str( 1:dq - 1 );
end

function [ code, n ] = getUnicode( str )
[ code, ~, ~, n ] = sscanf( str, '%x', 1 );
n = n - 1;
end

function [ code, n ] = getUnicodeRange( str )
code = zeros( 2, 0 );
n = 1;
while n < length( str ) && str( n ) ~= ']'
    [ c1, n ] = getChar( str, n );
    if str( n ) == '-'
        [ c2, n ] = getChar( str, n + 1 );
    else
        c2 = c1;
    end
    code( :, end  + 1 ) = [ c1, c2 ];%#ok
end
n = n - 1;
end

function [ c, n ] = getChar( str, n )
if strncmp( str( n:end  ), '#x', 2 )
    [ c, n1 ] = getUnicode( str( n + 2:end  ) );
    n = n + 2 + n1;
else
    c = double( str( n ) );
    n = n + 1;
end
end


function n = setRoot( cells, root )
names = cells( 1, : );
n = find( strcmp( root, names ), 1 );
if isempty( n )
    error( message( 'shared_pegparserlib:PEG:RootNotFound' ) );
end
end

function s = skipWS( s, n )
while n <= length( s.str ) && isspace( s.str( n ) )
    n = n + 1;
end
s.n = n;
end

function r = readRuleFile( name )
fid = fopen( name, 'rt' );
cleanup = onCleanup( @(  )fclose( fid ) );
r = {  };
while true
    str = fgetl( fid );
    if ~ischar( str ), break ;end
    r( end  + 1 ) = { str };%#ok
end
end

function printLine( depth, ip, str, varargin )
dbg = ' ';
mark = '  ';
if ~isreal( depth )
    im = imag( depth );
    if mod( im, 2 ) == 1
        dbg = '*';
    end
    if im > 99
        mark = '=>';
    end
    depth = real( depth );
end
indent = repmat( ' ', [ 1, depth ] );
str = [ mark, '%3d', dbg, indent, str, '\n' ];
fprintf( str, ip, varargin{ : } );
end

function printTrace( depth, str, varargin )
indent = repmat( ' ', [ 1, depth ] );
str = [ indent, str, '\n' ];
fprintf( str, varargin{ : } );
end

function cmd = findOpCode( breaks, routine, ip )
n = ( breaks( 1, : ) == routine ) & ( breaks( 2, : ) == ip );
if any( n )
    cmd = breaks( 3, n );
else
    error( message( 'shared_pegparserlib:PEG:MissingBreakpoint' ) );
end
end

function [ debugging, quitting ] = debugState( parser, s, pos, ip, accept, str )
debugging = true;
quitting = false;
while debugging && ~quitting
    dcmd = input( '[s,p,d,c,q,?]>> ', 's' );
    switch dcmd
        case '?'
            fprintf( [ 's = step\np = print state\n' ...
                , 'd = disassemble\nc = continue\nq = quit\n' ] );
        case 's'
            break ;
        case 'q'
            quitting = true;
        case 'c'
            debugging = false;
        case 'd'
            parser.disassemble( s.calls( 3, end  ), ip );
        case 'p'
            printDebugState( parser, s, pos, ip, accept, str );
    end
end
end

function printDebugState( parser, s, pos, ip, accept, str )
fprintf( 'position stack: %s\n', sprintf( '%d ', s.stack ) );
rs = rulemap( parser );
allnames = fieldnames( rs ).';
routines = s.calls( 3, : );
locs = [ s.calls( 2, 2:end  ), ip ];
c = [ allnames( routines );num2cell( locs ) ];
c = fliplr( c );
calls = sprintf( '  %s(%d)\n', c{ : } );
fprintf( 'call stack:\n%s', calls );
fprintf( 'accept: %d\n', accept );
e = min( pos + 20, length( str ) );
fprintf( 'position: %d  input: %s\n', pos, str( pos:e ) );
end

