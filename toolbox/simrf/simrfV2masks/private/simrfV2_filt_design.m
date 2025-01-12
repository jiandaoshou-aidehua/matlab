function filterObj=simrfV2_filt_design(mwsv)







    responseStr=regexprep(lower(mwsv.ResponseType),...
    '(ow|igh|and|ass|top)','');
    constFiltPiece={...
    'FilterType',mwsv.DesignMethod,...
    'ResponseType',mwsv.ResponseType,...
    'Implementation',mwsv.Implementation,...
    'Zin',mwsv.Rsrc,'Zout',mwsv.Rload};

    switch lower(mwsv.DesignMethod)
    case 'butterworth'
        if strcmp(mwsv.UseFilterOrder,'on')
            if strcmpi(responseStr,'bs')
                stopFreq=convert2hz(mwsv.(['StopFreq_',responseStr]),...
                mwsv.(['StopFreq_',responseStr,'_unit']));
                filterObj=rffilter(constFiltPiece{:},...
                'FilterOrder',mwsv.FilterOrder,...
                'StopbandFrequency',stopFreq,...
                'StopbandAttenuation',mwsv.StopAtten);
            else
                passFreq=convert2hz(mwsv.(['PassFreq_',responseStr]),...
                mwsv.(['PassFreq_',responseStr,'_unit']));
                filterObj=rffilter(constFiltPiece{:},...
                'FilterOrder',mwsv.FilterOrder,...
                'PassbandFrequency',passFreq,...
                'PassbandAttenuation',mwsv.PassAtten);
            end
        else

            passFreq=convert2hz(mwsv.(['PassFreq_',responseStr]),...
            mwsv.(['PassFreq_',responseStr,'_unit']));
            stopFreq=convert2hz(mwsv.(['StopFreq_',responseStr]),...
            mwsv.(['StopFreq_',responseStr,'_unit']));
            filterObj=rffilter(constFiltPiece{:},...
            'PassbandFrequency',passFreq,...
            'PassbandAttenuation',mwsv.PassAtten,...
            'StopbandFrequency',stopFreq,...
            'StopbandAttenuation',mwsv.StopAtten);
        end

    case 'chebyshev'
        if strcmp(mwsv.UseFilterOrder,'on')
            if strcmpi(responseStr,'bs')
                stopFreq=convert2hz(mwsv.(['StopFreq_',responseStr]),...
                mwsv.(['StopFreq_',responseStr,'_unit']));
                filterObj=rffilter(constFiltPiece{:},...
                'FilterOrder',mwsv.FilterOrder,...
                'PassbandAttenuation',mwsv.PassAtten,...
                'StopbandFrequency',stopFreq,...
                'StopbandAttenuation',mwsv.StopAtten);
            else
                passFreq=convert2hz(mwsv.(['PassFreq_',responseStr]),...
                mwsv.(['PassFreq_',responseStr,'_unit']));
                filterObj=rffilter(constFiltPiece{:},...
                'FilterOrder',mwsv.FilterOrder,...
                'PassbandFrequency',passFreq,...
                'PassbandAttenuation',mwsv.PassAtten);
            end
        else

            passFreq=convert2hz(mwsv.(['PassFreq_',responseStr]),...
            mwsv.(['PassFreq_',responseStr,'_unit']));
            stopFreq=convert2hz(mwsv.(['StopFreq_',responseStr]),...
            mwsv.(['StopFreq_',responseStr,'_unit']));
            filterObj=rffilter(constFiltPiece{:},...
            'PassbandFrequency',passFreq,...
            'PassbandAttenuation',mwsv.PassAtten,...
            'StopbandFrequency',stopFreq,...
            'StopbandAttenuation',mwsv.StopAtten);
        end

    case 'inversechebyshev'
        if strcmp(mwsv.UseFilterOrder,'on')
            if strcmpi(responseStr,'bs')
                stopFreq=convert2hz(mwsv.(['StopFreq_',responseStr]),...
                mwsv.(['StopFreq_',responseStr,'_unit']));
                filterObj=rffilter(constFiltPiece{:},...
                'FilterOrder',mwsv.FilterOrder,...
                'StopbandFrequency',stopFreq,...
                'StopbandAttenuation',mwsv.StopAtten);
            else
                passFreq=convert2hz(mwsv.(['PassFreq_',responseStr]),...
                mwsv.(['PassFreq_',responseStr,'_unit']));
                filterObj=rffilter(constFiltPiece{:},...
                'FilterOrder',mwsv.FilterOrder,...
                'PassbandFrequency',passFreq,...
                'PassbandAttenuation',mwsv.PassAtten,...
                'StopbandAttenuation',mwsv.StopAtten);
            end
        else

            passFreq=convert2hz(mwsv.(['PassFreq_',responseStr]),...
            mwsv.(['PassFreq_',responseStr,'_unit']));
            stopFreq=convert2hz(mwsv.(['StopFreq_',responseStr]),...
            mwsv.(['StopFreq_',responseStr,'_unit']));
            filterObj=rffilter(constFiltPiece{:},...
            'PassbandFrequency',passFreq,...
            'PassbandAttenuation',mwsv.PassAtten,...
            'StopbandFrequency',stopFreq,...
            'StopbandAttenuation',mwsv.StopAtten);
        end

    otherwise
        error(message('simrf:simrfV2errors:ValidRange',...
        'Design method',mwsv.DesignMethod,...
        'Butterworth or Chebyshev'))
    end
end

function x=convert2hz(x,funit)

    switch upper(funit)
    case 'KHZ'
        x=1e3*x;
    case 'MHZ'
        x=1e6*x;
    case 'GHZ'
        x=1e9*x;
    case 'THZ'
        x=1e12*x;
    end
end
