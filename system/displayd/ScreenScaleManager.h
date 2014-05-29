#ifndef __SCREEMSCALEMANAGER_H__
#define __SCREEMSCALEMANAGER_H__

class ScreenScaleManager {
	public:
		ScreenScaleManager();
		virtual ~ScreenScaleManager() {}
		void	SSMCtrlX(int display, int scalevalue); 
		void 	SSMCtrlY(int display, int scalevalue);
	private:
		int		SSMReadCfg();
		void	InitSysNode();
		char	MainDisplaySysNode[64];
		char	AuxDisplaySysNode[64];
};

#endif /*__SCREEMSCALEMANAGER_H__*/
