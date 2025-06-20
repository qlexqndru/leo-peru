{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    python3
    python3Packages.pandas
    python3Packages.openpyxl
    python3Packages.xlsxwriter
    python3Packages.pip
    zip
    awscli2
  ];
  
  shellHook = ''
    echo "Leo Peru Development Environment"
    echo "--------------------------------"
    echo "Available commands:"
    echo "  python generate_analysis.py - Run local analysis"
    echo "  ./deploy.sh - Create Lambda deployment package"
    echo "  aws - AWS CLI for deployment"
  '';
}