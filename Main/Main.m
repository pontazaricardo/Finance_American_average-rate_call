function main
    clc; 
    close all;
    clear all;
    format long;

    S = input('Enter stock price S=');
    X = input('Enter strike price X=');
    t = input('Enter maturity t=');
    sigma = input('Enter annual volatility sigma [example: 0.2]=');
    r1 = input('Enter interest rate r [example: 0.05] =');
    n = input('Enter number of periods n=');
    k = input('Enter number of states per node k=');

    %S=100;
    %X=70;
    %t=2;
    %sigma=0.2;
    %r1=0.05;
    %n=40;
    %k=5;
    
    %Result: 36.308
    
    %S=100;
    %X=50;
    %t=2;
    %sigma=0.3;
    %r1=0.1;
    %n=40;
    %k=5;
    
    %Result= 57.6465
 
    deltaT = t/n;
    r=r1*deltaT;
    u = exp(sigma*sqrt(deltaT));
    d = 1/u;
    p=(exp(r)-d)/(u-d);
        
    C=zeros(n+1,k+1);
    D=zeros(1,k+1);
    delta=0;
   
    for i=0:n
        for m=0:k
            C(i+1,m+1)=max(0,findA(m,n,i,S,k,u,d)-X);
        end
    end
    
    for j=n-1:-1:0
        for i=0:j
            for m=0:k
                a=findA(m,j,i,S,k,u,d);
                
                %Up calculations
                Au=((j+1)*a+S*(u^(j+1-i))*(d^i))/(j+2);
                [lup,x1]=findLUP(Au,j,i,S,k,u,d);
                Cu=x1*C(i+1,lup+1)+(1-x1)*C(i+1,lup+2);
                
                %Down calculations
                Ad=((j+1)*a+S*(u^(j-i))*(d^(i+1)))/(j+2);
                [ldown,x2]=findLDOWN(Ad,j,i,S,k,u,d);
                Cd=x2*C(i+2,ldown+1)+(1-x2)*C(i+2,ldown+2);
                
                %Calculate D
                D(m+1)=max(a-X,(p*Cu+(1-p)*Cd)*exp(-r));
                
                delta=(Cu-Cd)/(S*u-S*d);
            end
            for w=0:k
                C(i+1,w+1)=D(w+1);
            end
        end
    end
    disp('-------------------------')
    disp('The price is ')
    C(1,1)
    disp('Delta is')
    delta
    disp('-------------------------')
end

function amji=findA(m,j,i,S,k,u,d)
    Aminji=(1/(j+1))*(S*((1-d^(i+1))/(1-d))+S*(d^i)*u*((1-u^(j-i))/(1-u)));
    AminTerm=((k-m)/k)*Aminji;
    Amaxji=(1/(j+1))*(S*((1-(u^(j-i+1)))/(1-u))+S*(u^(j-i))*d*((1-d^i)/(1-d)));
    AmaxTerm=(m/k)*Amaxji;
    amji=AminTerm+AmaxTerm;
end

function [lvalue,x1]=findLUP(Au,j,i,S,k,u,d)
    epsilon=1e-04;
    lvalue=0;
    x1=1;
    for l=0:k-1
        AL1=findA(l,j+1,i,S,k,u,d);
        AL2=findA(l+1,j+1,i,S,k,u,d);
        if ((AL1-epsilon<=Au)&(Au<=AL2+epsilon))
            lvalue=l;
            if (AL1==AL2)
               x1=1;
            else
               x1=(Au-AL2)/(AL1-AL2);
            end
            break
        end
    end
end

function [lvalue,x2]=findLDOWN(Ad,j,i,S,k,u,d)
    lvalue=0;
    x2=1;
    epsilon=1e-04;
    for l=0:k-1
        AL1=findA(l,j+1,i+1,S,k,u,d);
        AL2=findA(l+1,j+1,i+1,S,k,u,d);
        if ((AL1-epsilon<=Ad)&(Ad<=AL2+epsilon))
            lvalue=l;
            if (AL1==AL2)
                x2=1;
            else
                x2=(Ad-AL2)/(AL1-AL2);
            end
            break
        end
    end
end